From: peter pilsl <pilsl@goldfisch.at>
Subject: Re: raid1-diseaster on reboot: old version overwrites new version
Date: Sat, 02 Apr 2005 20:10:34 +0200
Message-ID: <424EE01A.8070105@goldfisch.at>
References: <424EBDB7.2000106@goldfisch.at> <424ED7FA.4050007@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424ED7FA.4050007@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Moore wrote:
> 
> 
> peter pilsl wrote:
> 
>> The only explantion to me is, that I had the wrong entry in my 
>> lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
>> So maybe root was always mounted as /dev/hda6 and never as /dev/md2, 
>> which was started, but never had any data written to it. Is this a 
>> possible explanation?
> 
> 
> No.  The lilo.conf entry just tells the kernel where root is located.
> 
> Can you publish your /etc/fstab and fdisk -l output?
> 

thnx. following is the output of fstab, fdisk of both involved drives 
and my raidtab. (which reminds me to change the swap from raid to more 
single-partions)

---------------fstab-------------------

# cat /etc/fstab

/dev/md2 / reiserfs noatime,notail 1 1
/dev/md0 /boot ext2 noatime 1 2
/dev/md3 /var reiserfs noatime,notail 1 2
/dev/md1 swap swap defaults 0 0
/dev/md4 /data reiserfs noatime,notail 1 2

/dev/md5 /backup_cust reiserfs noatime,notail 1 2
/dev/md6 /data2 reiserfs noatime,notail 1 2
/dev/hdc8 /opt_noraid reiserfs noatime,notail 1 2

/dev/hdd7 /opt reiserfs noatime,notail 1 2

none /dev/pts devpts mode=0620 0 0
none /dev/shm tmpfs defaults 0 0
none /proc proc defaults 0 0

#/dev/hdb /mnt/cdrom auto 
user,iocharset=iso8859-1,exec,codepage=850,ro,noauto 0 0
#/dev/fd0 /mnt/floppy auto 
user,iocharset=iso8859-1,sync,exec,codepage=850,noauto 0 0



---------------fdisk-------------------

# fdisk -l /dev/hda

Disk /dev/hda: 255 heads, 63 sectors, 7297 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1         3     24066   fd  Linux raid autodetect
/dev/hda2             4        67    514080   fd  Linux raid autodetect
/dev/hda3            68      7297  58074975    5  Extended
/dev/hda5            68       705   5124703+  fd  Linux raid autodetect
/dev/hda6           706      1343   5124703+  fd  Linux raid autodetect
/dev/hda7          1344      5168  30724281   fd  Linux raid autodetect
/dev/hda8          5169      6443  10241406   fd  Linux raid autodetect
/dev/hda9          6444      7297   6859723+  fd  Linux raid autodetect

# fdisk -l /dev/hdc

Disk /dev/hdc: 16 heads, 63 sectors, 232581 cylinders
Units = cylinders of 1008 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1        48     24160+  fd  Linux raid autodetect
/dev/hdc2            49      1069    514584   fd  Linux raid autodetect
/dev/hdc3          1070    232581 116682048    5  Extended
/dev/hdc5          1070     11238   5125144+  fd  Linux raid autodetect
/dev/hdc6         11239     21407   5125144+  fd  Linux raid autodetect
/dev/hdc7         21408     82368  30724312+  fd  Linux raid autodetect
/dev/hdc8         82369    232581  75707320+  83  Linux

---------------raidtab-------------------

# cat /etc/raidtab
# /boot
raiddev       /dev/md0
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 3
     device    /dev/hdc1
     raid-disk 0
     device    /dev/hda1
     raid-disk 1
     device    /dev/hdd1
     raid-disk 2

# swap
raiddev       /dev/md1
raid-level    0
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hdc2
     raid-disk 0
     device    /dev/hda2
     raid-disk 1

# /
raiddev       /dev/md2
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hdc6
     raid-disk 0
     device    /dev/hda6
     raid-disk 1

# /var
raiddev       /dev/md3
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hda5
     raid-disk 0
     device    /dev/hdc5
     raid-disk 1

#  /data
raiddev       /dev/md4
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hda7
     raid-disk 0
     device    /dev/hdc7
     raid-disk 1


#  /back_customer
raiddev       /dev/md5
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hdd5
     raid-disk 0
     device    /dev/hda8
     raid-disk 1


# /data2
raiddev       /dev/md6
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hdd6
     raid-disk 0
     device    /dev/hda9
     raid-disk 1



thnx for your help,

peter



-- 
mag. peter pilsl
goldfisch.at
IT-management
tel +43 699 1 3574035
fax +43 699 4 3574035
pilsl@goldfisch.at
