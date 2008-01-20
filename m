From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: RE: mdadm error when trying to replace a failed drive in RAID5 array
Date: Sun, 20 Jan 2008 21:21:25 -0000
Message-ID: <017101c85baa$6a9c3850$0603a8c0@meanmachine>
References: <18323.45288.778496.719826@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18323.45288.778496.719826@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de] 
> Sent: 20 January 2008 20:37
> 
> > md: hdd1 has invalid sb, not importing!
> > md: md_import_device returned -22
> 
> In 2.6.18, the only thing that can return this message 
> without other more explanatory messages are:
> 
>   2/ If the device appears to be too small.
> 
> Maybe it is the later, though that seems unlikely.
> 

[root@space ~]# mdadm /dev/md0 --verbose --add /dev/hdd1
mdadm: added /dev/hdd1

HUGE thanks to Neil, and one white gold plated donkey award to me.

OK.  When I created /dev/md1 after creating /dev/md0, I was using a
mishmash of disks I had lying around.  As this selection of disks used
differing block sizes, I chose to create the raid partitions from the
first block, to a set size (+250G).  When I reinstalled the disk for
going into /dev/md0, I partitioned the disk the same way (+500G), which
it turns out isn't how I created the partitions when I created that
array.

So the device I was trying to add was about 22 blocks too small.  Taking
Neils suggestion and looking at /proc/partitions showed this up
incredibly quickly.

My sincere apologies for wasting all your time on a stupid error, and
again many many thanks for the solution...

md0 : active raid5 hdd1[5] sdd1[4] sdc1[2] sdb1[1] sda1[0]
      1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUU_U]
      [>....................]  recovery =  0.9% (4430220/488383936)
finish=1110.8min speed=7259K/sec

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.7/1233 - Release Date:
19/01/2008 18:37
 

