From: <me@heyjay.com>
Subject: Re: Sync rates?
Date: Fri, 7 May 2004 00:28:45 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000e01c433f4$337578f0$6705a8c0@a30>
References: <200405070244.i472iHB15917@www.watkins-home.com>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Weird, seems as if the faster the processor the longer the test takes.  I
ran it on 2 other machines, in addition to the one with raid.  Here are the
results.  What type of disks are you using?  Your results are almost twice
as fast as my fastest (which is machine 3 i.e. my slowest chip speed).

Jay

Machine 1 (the one in question), AMD 3200, 1 GB RAM, Disks on individual IDE
channels
platinum:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0              19686680   1195512  17491132   7% /
tmpfs                   452284         0    452284   0% /dev/shm
/dev/md1              39373624     32844  37340696   1% /opt
/dev/md2              39373624     32848  37340692   1% /home
/dev/md4              14974680     32872  14181136   1% /usr/local

platinum:~# time dd if=/dev/hda of=/dev/null bs=64k count=10000
10000+0 records in
10000+0 records out
655360000 bytes transferred in 166.335481 seconds (3939989 bytes/sec)

real    2m46.336s
user    0m0.004s
sys     2m13.280s


platinum:~# time dd if=/dev/hdc of=/dev/null bs=64k count=10000
10000+0 records in
10000+0 records out
655360000 bytes transferred in 171.632623 seconds (3818388 bytes/sec)

real    2m51.634s
user    0m0.004s
sys     1m33.162s

# Machine 2, PII 400 Mhz, the disks are master/slave
meir:~# df
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda4              4806936   1220040   3342708  27% /
/dev/hda1                46636       935     43293   3% /boot
/dev/hda5              4996728    938156   3804748  20% /home
/dev/hda6              3937220   2026628   1710588  55% /usr
/dev/hdb2              9843308   8246848   1096440  89% /opt
au:/usr/local/src     29530400   6731216  21299120  25% /usr/local/src

meir:~# time dd if=/dev/hda of=/dev/null bs=64k count=10000
10000+0 records in
10000+0 records out

real    2m48.300s
user    0m0.030s
sys     1m49.000s

Machine 1, PPro 180 Mhz, Master/Slave
abba:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1              9851308   2534948   6815940  28% /
tmpfs                   258204         0    258204   0% /dev/shm
/dev/hda3              7842996   3502032   3942552  48% /mnt/hda3


abba:~# time dd if=/dev/hda of=/dev/null bs=64k count=10000
10000+0 records in
10000+0 records out
655360000 bytes transferred in 56.396242 seconds (11620632 bytes/sec)

real    0m56.416s
user    0m0.120s
sys     0m11.960s



----- Original Message ----- 
From: "Guy" <bugzilla@watkins-home.com>
To: <me@heyjay.com>
Sent: Thursday, May 06, 2004 9:44 PM
Subject: RE: Sync rates?


> My system re-builds at 4000-5000K/sec/disk.  It has 14 disks.
> During a re-build the CPU load is below 5%.
> I have 2 CPUs, P3-500Mhz, 512Meg ram.
> During a re-build I don't notice any slowdown.  I had a disk fail and it
> re-build on the spare.  I did not know until hours after it was done.
>
> If you cat /proc/mdstat it will show the re-build rate.
> That rate is per disk, not an overall total.
>
> I would say your system has problems!
> Test each disk with dd.
> This is a read test!!
>
> time dd if=/dev/hda of=/dev/null bs=64k count=10000
>
> This should take less than a minute (34.6 seconds for me).
> If the above gives the same results on each disk, drop the count=10000.
>
> time dd if=/dev/hda of=/dev/null bs=64k
>
> Without the count=10000 it will read 100% of the disk, this may take an
hour
> or more.
> It will report a record count.
> Do this math to determine the speed in K per second.
> Records*64/number of seconds
>
> Replace "hda" with whatever is correct for you.
> Do this for each disk.
> I bet you find 1 disk is much slower than the others.
> Maybe a bad cable, don't know.
>
> Good luck,
> Guy
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of me@heyjay.com
> Sent: Thursday, May 06, 2004 10:02 PM
> To: Paul Clements
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Sync rates?
>
> My machine was idle during the rebuild.  When I say idle, I mean no one
> logged in, no user processes running (except me sshed into the box), no
> database, no I/O other than the rebuild.
>
> While the rebuild was going on my system was debilitated, totally slow to
> respond to ssh commands
>
> Jay
> ----- Original Message ----- 
> From: "Paul Clements" <paul.clements@steeleye.com>
> To: <me@heyjay.com>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Thursday, May 06, 2004 2:59 PM
> Subject: Re: Sync rates?
>
>
> > me@heyjay.com wrote:
> >
> > > platinum:~# cat /proc/sys/dev/raid/speed_limit_min
> > > 1000
> > > platinum:~# cat /proc/sys/dev/raid/speed_limit_max
> > > 200000
> >  > Are these acceptable?
> >
> > Well, those values are in KB/s. And, your resync rate is about:
> >
> > 120000000 / ( 24 * 60 * 60 ) = 1388 KB/s
> >
> > if my calculations are correct. I'd try bumping the min value up to say
> > 10000 and see if that speeds things up. Is there much I/O activity on
> > the system? That will slow down a resync quite a bit, too.
> >
> > --
> > Paul
> >
> >
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>

