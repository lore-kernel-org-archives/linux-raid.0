From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Sat, 15 Nov 2003 17:43:26 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOGEEGGOAA.jim@jimtreats.com>
References: <3FB65EA6.4080905@calixo.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FB65EA6.4080905@calixo.net>
To: david.anderson@calixo.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: David Anderson [mailto:david.anderson@calixo.net]
> Sent: 15 November 2003 17:13
> To: James R Bamford
> Subject: Re: Software Raid 1 data corruptions..
>
>
> > Can anyone give me any advice on this.. should i buy a hardware
> raid card
> > (which is effectively software as its cheap), or a true
> hardware raid card
> > thats quite expensive... should i install a different OS,  are there any
> > patches i can try.. should i abandon linux for raid and try
> using windows...
>
> You forget essential information:
>   - Your kernel version
>   - The tools you used to create the array (raidtools or mdadm)
>
> David Anderson
>

Sorry.. I'm only just starting with linux again (setting up at least i use
it all the time at work in a dumb mode :)

Kernel Version is 2.4.22-1.2115.nptl   (default fedora core 1 install)

I followed the HOWTO so used the methods outlined in that for setting up..
raidtools i believe.. I started looking into mdadm when i had problems with
the raid autodetection happening at boot.. i believe this got fixed without
mdadm as soon as i added the raid array into my fstab i think it tries a 2nd
time later on during boot and manages to setup then

My raid tab looks like

raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      4
        persistent-superblock   1
        device          /dev/hde1
        raid-disk       0
        device          /dev/hdh1
        raid-disk       1

my mdadm.conf has the following lines uncommented

DEVICE /dev/hde1 /dev/hdh1
ARRAY /dev/md0 UUID=f11b9f95:c0ef31ac:b1ff7661:8a9ac48f

mdadm -D /dev/md0 reveals this

[root@backup root]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Thu Nov 13 21:37:35 2003
     Raid Level : raid1
     Array Size : 156288256 (149.05 GiB 160.04 GB)
    Device Size : 156288256 (149.05 GiB 160.04 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Nov 15 17:21:43 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34       65        1      active sync   /dev/hdh1
           UUID : f11b9f95:c0ef31ac:b1ff7661:8a9ac48f
         Events : 0.13

/proc/mdstat is

[root@backup root]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hdh1[1] hde1[0]
      156288256 blocks [2/2] [UU]

unused devices: <none>

Is that about right? .. I will go ahead and memtest it.. I guess the point
is simultaneous read from the device is what could be making it susceptible
to problems that aren't visible in normal drive usage? as in why md5 works
reading of individual drives (even those a component of the array.. ohh is
it ok to mount the array component drives like this.. in read only to just
verify its contents etc?)

Thanks

Jim

