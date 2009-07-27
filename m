From: Andy Bailey <andy@hazlorealidad.com>
Subject: sdb failure - mdadm: no devices found for /dev/md0
Date: Mon, 27 Jul 2009 11:19:39 -0500
Message-ID: <1248711579.13147.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recently we had a disk failure on a sata disk /dev/sdb
it was in a mirror with /dev/sda, md0=boot and root combined, swap
mirrored as well. The system has Fedora Core 10 installed with recent
updates to kernel and mdadm tools.

My plan for the disk swap is below, we got as far as 4 rebooting.

On reboot grub displayed the grub prompt on a black screen. Ie no grub
boot menu. 

We changed back to the failing sdb disk.

the grub menu appeared however upon booting
we got
mdadm: no devices found for /dev/md0
mdadm: /dev/md2 has been started with 1 drive (out of 2)

and other messages that i didnt note down textually
bad superblock on /dev/md0
/dev/root device does not exist

I could boot from the rescue disk and it detected the linux instalation
and mounted it fine, mdstat looked fine, (the 2nd mdstat below)

The only "weird" thing that happened to md0 that didnt happen to the
other devices is that when the sdb disk started to fail, I did a 
mdadm /dev/md0 --grow -n 3
and added another partition from sdb that I had failed and removed from
another raid partition to it. I didnt zero the superblock of the 3rd
partition before adding it, I didnt think it was necessary- could that
be the problem.

All the partitions in mdadm.conf were specified by UUID.

Is it possible that the UUID changed somehow from the value that was
expected by the initrd mdadm.conf.?

I tried adding the kernel argument md=0,/dev/sda1,/dev/sdb1
no change.

Does this override the initrd's mdadm.conf? If not why not?

I tried remaking the initrd from the rescue disk,
chroot /mnt/sysimage
cd /boot
mkinitrd initrdraid {kernel version}

the mkinitrd script. didnt create anything, and no error message, so I
never got to test this out. 

When I didnt get the rescue disk to look for the root partitions:

I could create the mdadm.conf on the rescue root using
mdadm --examine --scan --config=partitions > /etc/mdadm.conf
mdadm -Av /dev/md0

The md0 partition appeared with the sda1 partion and could be fscked and
mounted.

Workaround: (after 2 days work) recover from backup!

Now the system has the boot+root partition not on raid and swap not on
raid, until I can figure out what went wrong.

Can anyone shed some light on what could have happened?

Specifically how is it that swapping the failing sdb for a new sdb and
then putting the failing sdb back again can cause a problem?

I took photos of the screen if anyone needs more info. And have backups
of root.

Thanks in advance,

Andy Bailey

--------------------------------------------------------------------
Plan

mdadm --set-faulty /dev/md0 /dev/sdb1
mdadm --set-faulty /dev/md0 /dev/sdb11

mdadm --set-faulty /dev/md1 /dev/sdb2
mdadm --set-faulty /dev/md2 /dev/sdb3
mdadm --set-faulty /dev/md3 /dev/sdb6
mdadm --set-faulty /dev/md4 /dev/sdb5
mdadm --set-faulty /dev/md5 /dev/sdb10

mdadm --set-faulty /dev/md6 /dev/sdb9
mdadm --set-faulty /dev/md7 /dev/sdb8


mdadm --remove /dev/md0 /dev/sdb1
mdadm --remove /dev/md0 /dev/sdb11

mdadm --remove /dev/md1 /dev/sdb2
mdadm --remove /dev/md2 /dev/sdb3
mdadm --remove /dev/md3 /dev/sdb6
mdadm --remove /dev/md4 /dev/sdb5
mdadm --remove /dev/md5 /dev/sdb10

mdadm --remove /dev/md6 /dev/sdb9
mdadm --remove /dev/md7 /dev/sdb8

grep sdb /proc/mdstat
check nothing appears

poweroff

3 replace the new disk for the old sata slot 1

4 check that the bios detects the disk

5 boot to multiuser

6 as root

sfdisk /dev/sdb < /root/sfdisk.sdb

fdisk /dev/sdb
order: p
check partition type "fd"
(option t, partition #, hexadecimal code fd)


mdadm --add /dev/md0 /dev/sdb1

mdadm --add /dev/md1 /dev/sdb2
mdadm --add /dev/md2 /dev/sdb3
mdadm --add /dev/md3 /dev/sdb6
mdadm --add /dev/md4 /dev/sdb5
mdadm --add /dev/md5 /dev/sdb10


monitor with
watch "cat /proc/mdstat"

when finished 5

mdadm --add /dev/md6 /dev/sdb9
mdadm --add /dev/md7 /dev/sdb8
mdadm --add /dev/md8 /dev/sdb7
mdadm --add /dev/md9 /dev/sdb11

---------------------------------------------------------------------------------------
This is the first mail message from mdadmmonitor after we failed sdb1
P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1] [raid6] [raid5] [raid4] 
md3 : active raid1 sdb6[1] sda6[0]
      102398208 blocks [2/2] [UU]
      
md4 : active raid1 sda5[0] sdb5[1]
      102398208 blocks [2/2] [UU]
      
md5 : active raid1 sda10[0] sdb10[1]
      20482752 blocks [2/2] [UU]
      
md6 : active raid1 sda9[0] sdb9[1]
      51199040 blocks [2/2] [UU]
      
md7 : active raid1 sda8[0] sdb8[1]
      51199040 blocks [2/2] [UU]
      bitmap: 0/196 pages [0KB], 128KB chunk

md8 : active raid1 sda7[0]
      51199040 blocks [2/1] [U_]
      bitmap: 0/196 pages [0KB], 128KB chunk

md9 : active raid1 sda11[0]
      35784640 blocks [2/1] [U_]
      bitmap: 2/137 pages [8KB], 128KB chunk

md1 : active raid1 sda2[0] sdb2[1]
      30716160 blocks [2/2] [UU]
      
md2 : active raid1 sda3[0] sdb3[1]
      12289600 blocks [2/2] [UU]
      
md0 : active raid1 sdb11[2] sda1[0] sdb1[3](F)
      30716160 blocks [3/2] [U_U]
-----------------------------------------------
This is the last message after failing all sdb partitions

Personalities : [raid1] [raid6] [raid5] [raid4] 
md3 : active raid1 sdb6[2](F) sda6[0]
      102398208 blocks [2/1] [U_]
      
md4 : active raid1 sda5[0] sdb5[2](F)
      102398208 blocks [2/1] [U_]
      
md5 : active raid1 sda10[0] sdb10[2](F)
      20482752 blocks [2/1] [U_]
      
md6 : active raid1 sda9[0] sdb9[2](F)
      51199040 blocks [2/1] [U_]
      
md7 : active raid1 sda8[0] sdb8[1](F)
      51199040 blocks [2/1] [U_]
      bitmap: 0/196 pages [0KB], 128KB chunk

md8 : active raid1 sda7[0]
      51199040 blocks [2/1] [U_]
      bitmap: 0/196 pages [0KB], 128KB chunk

md9 : active raid1 sda11[0]
      35784640 blocks [2/1] [U_]
      bitmap: 2/137 pages [8KB], 128KB chunk

md1 : active raid1 sda2[0] sdb2[2](F)
      30716160 blocks [2/1] [U_]
      
md2 : active raid1 sda3[0] sdb3[2](F)
      12289600 blocks [2/1] [U_]
      
md0 : active raid1 sdb11[3](F) sda1[0] sdb1[4](F)
      30716160 blocks [3/1] [U__]
      
unused devices: <none>



