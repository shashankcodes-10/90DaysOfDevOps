# Day 13 – Linux Volume Management (LVM)

## Objective

Practice Linux Logical Volume Management (LVM) by checking storage, formatting and mounting volumes, and extending a logical volume.

---

# Task 1: Check Current Storage

## Check Disk Space

```bash
df -h
```

### What I observed

Used `df -h` to check the available and used disk space on the system and mounted filesystems.

---

## List Block Devices

```bash
lsblk
```

### What I observed

`lsblk` displayed the available disks, partitions, and logical volumes attached to the system.

---

# Task 2: Work with an Existing LVM Volume

I practiced working with the existing LVM setup:

- Volume Group: `tws-vg`
- Logical Volume: `tws-lv`

---

## Format the Logical Volume

```bash
mkfs.ext4 /dev/tws-vg/tws-lv
```

### What I observed

The logical volume was formatted with the `ext4` filesystem.

---

# Task 3: Mount the Logical Volume

## Create Mount Point

```bash
mkdir /mnt/tws-space
```

### What I observed

Created `/mnt/tws-space` as the mount point for the logical volume.

---

## Mount the Logical Volume

```bash
mount /dev/tws-vg/tws-lv /mnt/tws-space
```

### What I observed

The logical volume was mounted successfully at `/mnt/tws-space`.

---

## Verify the Mounted Filesystem

```bash
df -h
```

### What I observed

Verified that `/dev/tws-vg/tws-lv` was mounted and displayed its available storage.

---

## Check Block Devices Again

```bash
lsblk
```

### What I observed

Confirmed the logical volume and its mount point using the block-device tree.

---

# Task 4: Extend the Logical Volume

## Extend the Logical Volume

```bash
lvextend -L +2G /dev/tws-vg/tws-lv
```

### What I observed

Increased the logical volume size by 2 GB.

---

## Verify the Logical Volume

```bash
lsblk
```

### What I observed

Checked the logical volume size after extending it.

---

## Check Filesystem Size

```bash
df -h
```

### What I observed

The logical volume size increased, but the filesystem may still need to be resized separately.

---

# Task 5: Extend the Logical Volume and Filesystem Together

I also practiced using the `-r` option with `lvextend`.

```bash
lvextend -L +2G -r /dev/tws-vg/tws-lv
```

### What I observed

The `-r` option was used to resize the filesystem along with the logical volume.

I also practiced the equivalent command with the options written in a different order:

```bash
lvextend -r -L +2G /dev/tws-vg/tws-lv
```

---

## Verify the New Size

```bash
df -h
```

### What I observed

Checked the filesystem size after extending and resizing it.

---

```bash
lsblk
```

### What I observed

Confirmed the updated logical volume size in the block-device hierarchy.

---

# Task 6: Format and Mount a Separate Block Device

I also practiced working with a separate block device:

```text
/dev/nvme3n1
```

## Create Mount Point

```bash
mkdir /mnt/tws-space2
```

### What I observed

Created `/mnt/tws-space2` as a mount point.

---

## Format the Device

```bash
mkfs -t ext4 /dev/nvme3n1
```

### What I observed

Formatted `/dev/nvme3n1` with the `ext4` filesystem.

---

## Mount the Device

```bash
mount /dev/nvme3n1 /mnt/tws-space2
```

### What I observed

Mounted `/dev/nvme3n1` at `/mnt/tws-space2`.

---

## Verify Storage

```bash
df -h
```

### What I observed

Verified that the newly mounted filesystem was visible in the disk usage output.

---

# Commands Practiced

```bash
df -h

lsblk

mkdir /mnt/tws-space

mkfs.ext4 /dev/tws-vg/tws-lv

mount /dev/tws-vg/tws-lv /mnt/tws-space

lvextend -L +2G /dev/tws-vg/tws-lv

lvextend -L +2G -r /dev/tws-vg/tws-lv

lvextend -r -L +2G /dev/tws-vg/tws-lv

mkdir /mnt/tws-space2

mkfs -t ext4 /dev/nvme3n1

mount /dev/nvme3n1 /mnt/tws-space2

df -h

lsblk
```

---

# What I Learned

1. **`lsblk`** is useful for understanding the disk and logical-volume structure of a Linux system.

2. **`mount`** connects a filesystem or block device to a directory so that it can be accessed through the Linux filesystem.

3. **`lvextend`** can increase the size of an LVM logical volume. Using `-r` allows the filesystem to be resized along with the logical volume.

---

# Key LVM Flow

```text
Physical Disk
     ↓
Physical Volume (PV)
     ↓
Volume Group (VG)
     ↓
Logical Volume (LV)
     ↓
Filesystem (ext4)
     ↓
Mount Point
```

In this practice, I worked with the existing:

```text
tws-vg
   ↓
tws-lv
   ↓
ext4
   ↓
/mnt/tws-space
```

---

# Verification

The following commands were used to verify the storage configuration:

```bash
lsblk
df -h
```

These commands helped confirm the logical volume size, filesystem, and mount points.
