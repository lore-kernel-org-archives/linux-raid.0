From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 08:09:41 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1040805075409.30269A-100000@Maggie.Linux-Consulting.com>
References: <16658.16220.904470.117836@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16658.16220.904470.117836@gargle.gargle.HOWL>
To: John Stoffel <stoffel@lucent.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya john

On Thu, 5 Aug 2004, John Stoffel wrote:

> The root filesystems are all on SCSI disks, and I have a pair of WD
> 120gb drives on a Promise HPT302 controller which are mirrored.  These

if it was me, i'd throw away the highpoint controller ... it aint worth
the risk of losing your data
	- i prefer sw raid and its flexibility over expensive hw raid 

isn't hpt (rocketraid) hardware raid ??
	- why are we using mdadm tools on a hw raid controller ??

> .... I noticed that /dev/md0 had lost one of
> it's two disks, /dev/hdg.  I've been trying to re-add it back in, but
> I can't.  

you should monitor the raid so that you know if a disk crashed within  few
hours .. otherwise, you lose all data on the entire raid array

> What I'm doing is setting up the two disks mirrored as /dev/md0 using
> /dev/hde1 and /dev/hdg1.  Then I've setup a volume group using
> DeviceMapper to hold a pair of filesystems on there, so that I can
> grow/shrink them as needed down the line.  So far so good.  The data
> is all there and I can still access it no problem, but I can't get my
> data mirrored again!

than it's NOT "so good" so far ... ( raid is broken )

> I've run a complete badblocks on /dev/hdg and it passes without any
> problems. 

good

>     # mdadm -QE --scan
>     ARRAY /dev/md0 level=raid1 num-devices=2 UUID=2e078443:42b63ef5:cc179492:aecf0094
>        devices=/dev/hde1
>     ARRAY /dev/md0 level=raid1 num-devices=2 UUID=9835ebd0:5d02ebf0:907edc91:c4bf97b2
>        devices=/dev/hde
> 
> This bothers me, why am I seeing two different UUIDs here?

one is the entire disk ... other is a partition
 	
>     # mdadm --detail /dev/md0
> 	Update Time : Thu Aug  5 09:33:35 2004
> 	      State : clean, degraded

degraded is good... if you lost one disk
 
> 	Number   Major   Minor   RaidDevice State
> 	   0      33        1        0      active sync   /dev/hde1
> 	   1       0        0       -1      removed

good ... one removed

>     # mdadm --assemble /dev/md0 --auto --scan --update=summaries --verbose
>     mdadm: looking for devices for /dev/md0
>     mdadm: /dev/hde has wrong uuid.
>     mdadm: /dev/hde1 is identified as a member of /dev/md0, slot 0.

fun times w/ hw raid..
> 
>     jfsnew:/etc/init.d# mdadm /dev/md0 -a /dev/hdg1
>     mdadm: hot add failed for /dev/hdg1: Invalid argument

how about simple "raid stop" and "raid start" or at least the
commands that came with (possibly non-hw-raid) hpt302 ...
 
> And this just fails.  I get the following error in /var/log/syslog.  
> 
>     Aug  5 09:58:09 jfsnew kernel: md: trying to hot-add hdg1 to md0 ... 
>     Aug  5 09:58:09 jfsnew kernel: md: could not lock hdg1.
>     Aug  5 09:58:09 jfsnew kernel: md: error, md_import_device() returned -16
> 
> Which doesn't seem to make any sense.  Can someone tell me what the
> heck is going on here?  

i think you're using mdadm ( sw raid tools ) on a hardware raid controller 

c ya
alvin

