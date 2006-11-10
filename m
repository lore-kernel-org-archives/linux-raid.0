From: David <lists@edeca.net>
Subject: Swap initialised as an md?
Date: Fri, 10 Nov 2006 10:29:55 +0000
Message-ID: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two devices mirrored which are partitioned like this:

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63    30716279    15358108+  fd  Linux raid autodetect
/dev/sda2        30716280    71682029    20482875   fd  Linux raid autodetect
/dev/sda3        71682030   112647779    20482875   fd  Linux raid autodetect
/dev/sda4       112647780   156248189    21800205    5  Extended
/dev/sda5       112647843   122881184     5116671   82  Linux swap / Solaris
/dev/sda6       122881248   156248189    16683471   fd  Linux raid autodetect

My aim was to have the two swap partitions both mounted, no RAID (as I  
didn't see any benefit to that, but if I'm wrong then I'd appreciate  
being told!).  However it seems that sda5 seems to be recognised as an  
md anyway at boot, so swapon does not work correctly.  When  
initialising the partitions with mkswap, the RAID array is confused  
and refuses to boot until the superblocks are fixed.

At boot, the kernel says:

[17179589.184000] md: md3 stopped.
[17179589.184000] md: bind<sdb5>
[17179589.188000] md: bind<sda5>
[17179589.188000] raid1: raid set md3 active with 2 out of 2 mirrors

Then /proc/mdstat says:

md3 : active raid1 sda5[0] sdb5[1]
       5116544 blocks [2/2] [UU]

In /etc/mdadm/mdadm.conf, the following is present which was created  
by the installer and only lists 4 arrays.  In actual fact sdx6 is  
recognised as the fifth array md4.

DEVICE partitions
ARRAY /dev/md3 level=raid1 num-devices=2  
UUID=75575384:5fbe10ed:a5a46544:209740b3
ARRAY /dev/md2 level=raid1 num-devices=2  
UUID=5d133655:1d034197:c1c19528:56cc420a
ARRAY /dev/md1 level=raid1 num-devices=2  
UUID=2cda8230:b2fde7b4:97082351:880c918a
ARRAY /dev/md0 level=raid1 num-devices=2  
UUID=7f9abf32:c86071fd:3df4db9d:26ddd001

As /etc is on md0 I doubt this configuration file has anything to do  
with the kernel recognising and setting the arrays active.  However,  
is there any reason that the swap partitions (which have the correct  
partition type) are initialised as an md?  Can I stop it anyhow, or is  
the correct method to have them as an md with the md initialised as  
swap?

Brief details are the same as my previous mails last week: 2.6.15,  
mdadm 1.12.0 (on md0, so I can't see that it is at fault).

Thanks,

David
