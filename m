From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Re: Problem with RAID-5 on SuSE 9.1 (cp hangs, high system load, cpu waits)
Date: Thu, 27 May 2004 00:04:47 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040526155142.M13344@liquid-nexus.net>
References: <S265614AbUEZPjm/20040526153943Z+292@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S265614AbUEZPjm/20040526153943Z+292@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a general comment - I may be wrong but this:

> md0 : active raid5 hdh1[4] hdg1[3] hdd1[2] hdc1[1] hda1[0]
>       480242688 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]

looks like you have two disks on one IDE bus (hdc1 and hdd1 / hdg1 and hdh1)
which isn't a good idea for IDE as, typically, both devices will fail if
there's a problem with one drive on that channel (I think its mentioned in the
s/ware RAID howto). 

I have:

md0 : active raid5 hdk1[3] hdi1[2] hdg1[1] hde1[0]
      234444288 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

Each disk is master on its own IDE bus.

I wonder if this is contributing to your problem? I'm no expert on RAID but
are there any IDE related error messages in your logs?

Oh and your motherboard is using a KT266A chipset - I personally won't touch a
VIA chipset since that whole PCI / Soundblaster fiasco (I still have
nightmares). AFAIK the KT266A has PCI issues which have some kind of
workaround in the Linux kernel, however it might be a factor in your situation. 

--


---------- Original Message -----------
From: "Christoph Zimmerli" <zeratul@gmx.ch>
To: <linux-raid@vger.kernel.org>
Sent: Wed, 26 May 2004 17:39:43 +0200
Subject: Problem with RAID-5 on SuSE 9.1 (cp hangs, high system load, cpu waits)

> Hi there!
> 
> I'm running SuSE 9.1 on my fileserver with 6 hds:
> 1 40gb IBM system disk on the onboard ide0
> 5 120gb Maxtor disks, 1 with the system disk on onboard ide0 and 4 
> on an Adaptec 1200A.
> 
> I configured the 5 120gb disks as software RAID-5 array, using ext3 
> as fs. The system itself runs ok like that, but strange things 
> happen, when I start to copy files onto/from the RAID: - Copying 
> starts normally - Copying hangs, no more data is transferred - The 
> CPU is almost 100% in wait state - The system load increases 
> steadily - iowait is huge but the disks are idle
> 
> If I react quick, I can kill the cp process, and everything returns 
> to normality. But if you wait too long, the process can't be killed 
> anymore. The problem is, you can't even shutdown the pc, because the 
> system seems to wait for something. I then pressed the reset button. 
> When booting, the system reports, it's recovering the journal of md0,
>  and hangs there. I waited about 15h at max, but nothing happened. 
> When resetting again, the system came up flawlessly, and did about 
> 1.5h of RAID-resync. But when copying again, the same things would happen.
> 
> I was able to have the system running for half a week with all the hardware
> inside, all disks connected, but each disk mounted as /disk1 etc. 
> with ext3. I then copied around some gb, but there was no high load 
> or so, and every cp terminated. I read in the list, that there were 
> some problems with ext3 as fs, so I changed the fs to Reiser, but 
> that didn't help.
> 
> After these tests I think, that it has to be something with the RAID 
> itself, or the simultaneous disk access in RAID-mode.
> 
> Any ideas about how to solve this problem would be highly appreciated!
> 
> Have a nice day!
> Christoph
> 
> -----------------------------------------------
> System Information:
> 
> AMD AthlonXP 1800+
> 512mb RAM
> Shuttle AK31
> ASUS DVD-ROM
> 1 IBM IC35L040AVER07-0 (40gb system disk)
> 5 Maxtor 6Y120L0 (120gb storage disks)
> Adaptec 1200A PCI IDE Controller
> 
> -----------------------------------------------
> /proc/version
> 
> Linux version 2.6.4-54.5-default (geeko@buildhost) (gcc version 
> 3.3.3 (SuSE
> Linux)) #1 Fri May 7 21:43:10 UTC 2004
> 
> -----------------------------------------------
> /proc/mdstat:
> 
> md0 : active raid5 hdh1[4] hdg1[3] hdd1[2] hdc1[1] hda1[0]
>       480242688 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]
> 
> unused devices: <none>
> 
> -----------------------------------------------
> /etc/fstab
> 
> /dev/hde3            /                    ext3       acl,user_xattr  
>       1 1 /dev/hde1            /boot                ext3       acl,
> user_xattr        1 2 /dev/hde4            /var                 ext3 
>       acl,user_xattr        1 2 /dev/hde2            swap            
>      swap       pri=42                0 0 devpts               
> /dev/pts             devpts     mode=0620,gid=5       0 0 proc       
>           /proc                proc       defaults              0 0 
> usbfs                /proc/bus/usb        usbfs      noauto          
>       0 0 sysfs                /sys                 sysfs      
> noauto                0 0 /dev/dvd             /media/dvd           subfs
> fs=cdfss,ro,procuid,nosuid,nodev,exec,iocharset=utf8 0 0
> /dev/fd0             /media/floppy        subfs
> fs=floppyfss,procuid,nodev,nosuid,sync 0 0
> /dev/md0             /storage             reiserfs   acl,user_xattr
> 
> -----------------------------------------------
> /proc/dma
> 
>  4: cascade
> 
> -----------------------------------------------
> /proc/interrupts
> 
>            CPU0
>   0:   11052606          XT-PIC  timer
>   1:         10          XT-PIC  i8042
>   2:          0          XT-PIC  cascade
>   5:      13236          XT-PIC  ide0, ide1, eth1, VIA8233
>   8:          2          XT-PIC  rtc
>   9:          0          XT-PIC  acpi
>  11:      79755          XT-PIC  eth0, uhci_hcd, uhci_hcd, uhci_hcd
>  12:         50          XT-PIC  i8042
>  14:      43472          XT-PIC  ide2
>  15:       7081          XT-PIC  ide3
> NMI:          0
> LOC:          0
> ERR:          1
> MIS:          0
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

