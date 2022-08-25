package com.iamatum.hello;

public class HelloWorldPing {

    public static void main(String[] args) throws InterruptedException {
        for(int i=0;i< 100;i++){
            System.out.println("Hello world ping ! " + i);
            Thread.sleep(1000);
        }
    }
}
