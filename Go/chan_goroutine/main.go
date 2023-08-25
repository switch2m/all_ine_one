Go Routines:
A Go routine is a lightweight thread of execution. It allows you to run functions concurrently, meaning they can execute simultaneously without blocking the main program.
Go routines are extremely efficient, and you can have thousands or even more running concurrently without much overhead.

Channels:
Channels are a way for Go routines to communicate and synchronize with each other. They provide a means to send and receive data between concurrent tasks. 
Channels ensure safe communication and coordination, preventing data races and race conditions.



package main

import (
	"fmt"
	"sync"
)

func sum(numbers []int, ch chan int, wg *sync.WaitGroup) {
	defer wg.Done() // Notify the WaitGroup that this function is done
	result := 0
	for _, num := range numbers {
		result += num
	}
	ch <- result // Send the result to the channel
}

func main() {
	numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

	ch := make(chan int)    // Create a channel
	var wg sync.WaitGroup   // Create a WaitGroup to wait for goroutines to finish

	// Launch two goroutines to calculate sum concurrently
	wg.Add(2) // Add the number of goroutines to wait for
	go sum(numbers[:len(numbers)/2], ch, &wg)
	go sum(numbers[len(numbers)/2:], ch, &wg)

	// Wait for the goroutines to finish
	wg.Wait()

	// Receive and sum the results from the channel
	totalSum := <-ch + <-ch
	close(ch) // Close the channel

	fmt.Println("Total Sum:", totalSum)
}


1. wg.Done(): The purpose of wg.Done() is to notify the sync.WaitGroup that the Go routine has finished its work. 
In other words, it decrements the counter that was previously incremented using wg.Add(). This is important for the main function to know when all the Go routines have completed their work.

By deferring wg.Done(), you ensure that the counter will be decremented properly even if the function exits abruptly (e.g., due to a panic or an early return). 
This helps maintain the integrity of the synchronization provided by the WaitGroup.

2. wg.Wait():
The line wg.Wait() is used at the end of the main function. It instructs the main function to wait until all the Go routines added to the sync.WaitGroup have called wg.Done(). 
Only after the counter in the WaitGroup reaches zero will the Wait() call return, allowing the program to continue executing.
In the example, the main function launches two Go routines using go sum(...), and each of these Go routines increments the WaitGroup counter using wg.Add(2). 
By calling wg.Done() within each Go routine and then waiting for the counter to reach zero with wg.Wait(), 
the main function ensures that it will wait until both Go routines have completed their work before proceeding further.
