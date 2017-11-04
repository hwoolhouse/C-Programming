#include "mbed.h"
#include "ADXL362.h"
#include "math.h"
#include "stdio.h"
/*Object Declaration*/
Serial pc(USBTX,USBRX); /*Serial interface */
ADXL362 adxl362(p11, p12, p13, p10); /*Accelerometer*/
LocalFileSystem local("local");/*Ceate Mbed local filesystem*/


int main()
{
    /*Configure SPI interface and accelerometer*/
    adxl362.init_spi();
    adxl362.init_adxl362();
    wait(0.1);
    /*Set default values for parameters*/
    int N=50;
    float T=0.1;
    /*Read settings file*/
    FILE *fp=fopen("/local/settings.txt", "r"); /*Open the settings file for reading*/
     while (!feof(fp)) {
    fscanf(fp,"%d %f",&N,&T);
    }
    fclose(fp);
    
    /*variables for collecting data*/
    int8_t xData= 0 ;
    int8_t yData = 0;
    int8_t zData = 0;
    uint8_t reg;

    int i=0;
    while(i<N) {
        /*Collect data*/
        reg = adxl362.ACC_ReadReg(FILTER_CTL);
        //pc.printf("FILTER_CTL = 0x%X\r\n", reg);
        adxl362.ACC_GetXYZ8(&xData, &yData, &zData);
        pc.printf("%i\n%i\n%i\n",(int)xData, (int)yData, (int)zData);
        pc.printf("F");
        wait(T); /*Wait T for sample period*/
        i++;
    }
}

