

# Routing and Spectrum Allocation in Elastic Optical Networks

## 📝 Overview

This project, developed as part of a research internship at the National Institute of Technology (NIT), Rourkela, simulates a routing and spectrum allocation (RSA) algorithm for Elastic Optical Networks (EONs). The simulation finds the K-shortest paths for all possible source-destination pairs in a given network topology and allocates spectral slots using a first-fit strategy. The primary goal is to analyze the network's performance by calculating and plotting the **Blocking Probability** against the number of connection requests.

The simulation is implemented in **MATLAB** and utilizes **Yen's algorithm** to find the K-shortest paths, which in turn relies on **Dijkstra's algorithm** for single shortest path computation.

---

## ✨ Features

* **K-Shortest Path Calculation**: Implements Yen's algorithm to find up to `k` alternative paths for each connection request.
* **First-Fit Spectrum Allocation**: Simulates a dynamic resource allocation strategy where the first available contiguous block of spectral slots is assigned to a connection.
* **Blocking Probability Analysis**: Calculates and visualizes the probability of a connection being blocked due to the unavailability of spectral resources.
* **Network Visualization**: The network topology is defined by an adjacency matrix, which can be easily modified to test different network structures.

---

## ⚙️ How It Works

The simulation follows a systematic process to evaluate the network's performance:

1.  **Network Initialization**: A network topology is defined using an adjacency matrix (`netMatrix`) where values represent the cost (e.g., distance) between nodes. Infinite values indicate no direct link.
2.  **Iterate Connections**: The main script (`newtestcodepath.m`) loops through every possible source-destination pair in the network to simulate connection requests.
3.  **Find K-Shortest Paths**: For each pair, the `YenskShortestPath.m` function is called. This function uses `dijkstra_algorithm.m` iteratively to find the `k` shortest paths between the source and destination.
4.  **Attempt Spectrum Allocation**:
    * For each of the `k` paths found, the simulation attempts to allocate the required number of spectral slots (in this implementation, a random number between 1 and 10).
    * It uses a **first-fit** approach, searching for the first available contiguous block of slots along all links in the path.
    * If allocation is successful for one of the `k` paths, the connection is established, and the spectral slots are marked as used.
5.  **Handle Blocked Connections**: If none of the `k` paths have sufficient contiguous spectral slots, the connection request is **blocked**.
6.  **Calculate Blocking Probability**: After iterating through all connection requests, the simulation calculates the cumulative blocking probability at each step and plots the result, showing how the probability of blocking evolves as more connections are requested.


---

## 📂 File Descriptions

* `newtestcodepath.m`: The main executable script. It defines the network, manages the simulation loop, calls the pathfinding and allocation logic, and plots the final results.
* `YenskShortestPath.m`: A function that implements Yen's k-shortest path algorithm. It finds `k` loop-less paths for a given source-destination pair.
* `dijkstra_algorithm.m`: A standard implementation of Dijkstra's algorithm used by `YenskShortestPath.m` to find the single shortest path in a graph.
* **Reference Papers/**: This directory contains the research papers that provided the theoretical foundation for this project.
* **Outputs/**: This directory includes sample command window outputs and the generated graph of blocking probability.

---

## ▶️ How to Run

1.  Ensure you have **MATLAB** installed.
2.  Open the `newtestcodepath.m` file in the MATLAB IDE.
3.  Click the **"Run"** button or type `newtestcodepath` in the MATLAB command window and press Enter.
4.  The script will execute, displaying the progress for each source-destination pair in the command window. Upon completion, it will generate a plot showing the blocking probability versus the number of connections.

---

## 📊 Results

The primary output of this simulation is a plot of the **Probability of Blocking vs. the Number of Connections**. This graph demonstrates how the network's performance degrades as more resources are consumed.

The command window output provides a detailed log of the simulation, showing which paths were tested, how many spectral slots were requested, and whether the allocation was successful or resulted in a block.

---

## 🧑‍💻 Author & Acknowledgments

* **Author**: *Shubhranshu Sekhar Panda*
* This project was completed as part of a research internship at the **Department of Electronics and Communication Engineering, NIT Rourkela**.
* I would like to extend my gratitude to my supervisor, *Dr Sadanand Behera*, for their invaluable guidance and support throughout this research.
