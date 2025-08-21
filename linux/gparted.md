# Linux Partitioning

## Basic Partitioning

### Recommended Partitions

| **Partition** | **Type**         | **Size**          | **Description**                                      |
|---------------|------------------|-------------------|------------------------------------------------------|
| `/`           | Root Partition    | At least 20 GB    | Contains the root filesystem and all system files.   |
| `/home`       | Data Partition     | Variable (e.g., 20-100 GB or more) | Contains user data and personal files.                |
| `swap`        | Swap Partition     | 1-2 GB (or more, depending on needs) | Virtual memory that complements RAM.                   |
| `/boot`       | Boot Partition      | 512 MB - 1 GB     | Contains bootloader and kernel files.                 |

### Example Partitioning

1. **Root (`/`)**: This partition is the core of your system. It should be large enough to store the operating system and all installed applications. For most users, 20-30 GB is sufficient, but more space can be useful if you plan to install many applications.

2. **Home (`/home`)**: This partition stores your personal files and settings. If you have a lot of data or plan to install many applications, you should allocate more space to this partition.

3. **Swap**: If you have 64 GB of RAM, a swap partition of 1-2 GB is usually sufficient. Swap is used when RAM is full and can also be useful for hibernation.

4. **Boot (`/boot`)**: This partition is optional but useful if you have multiple operating systems or special boot configurations. 512 MB to 1 GB is typically sufficient.

### Encryption 

Root, Home, Swap
Dnt encrypt boot
