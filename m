From: "Jason C. Leach" <jleach@ocis.net>
Subject: Re: Promise SX6000 is a POS.
Date: Wed, 07 Apr 2004 17:27:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40749C58.9040009@ocis.net>
References: <1CEC5A75042ED51180E300A024E99257AD8227@zeus.sc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1CEC5A75042ED51180E300A024E99257AD8227@zeus.sc.com>
To: "Petriz, Pablo" <ppetriz@siscat.com.ar>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Petriz, Pablo wrote:

>We have a similar configuration (SX6000) and for the same purpose, store GIS
>files: shape files, tifs and jpg (not databases), it's like an image file
>repository. 
>  
>
> <snip>

I have a Promise SX6000 w/ 6 WD2000 EIDE drives and 128MB cache. I 
flashed the BIOS to the latest and am using Debian Woody with Linux 
kernel v2.4.25.  I use the Promise SCSI drive from the website, it 
compiles with out any problems. I think I got i2o working, but since 
this driver worked just find I went with it. The system hardware is an 
AMD AthlonXP 2500+ w/ 512M RAM.  I have 1 RAID5 array with 5 of the 
disks (800G) (reiserfs) and 1 hot spare.  So far so good.  I would have 
liked to not have a hot spare, but am too paranoid the office will not 
call me if a disk fails.  On a side note, you will hear the SX6000 start 
beeping if a drive has problems.  If the drive has not completley 
calved, the card will atempt to rebuild the drive. You can use the 
system during this time if you don't mind the beeping.  If the disk 
rebulds, the beeping will stop and life is good. If the drive fails to 
rebuld you MUST replace it (the beeping will continue).  I have had a 
rebuid occure once due to a power falure. The array rebuld just fine, I 
think it takes about 8-12h at 800G-1Tb storage.

I installed sysstat or more specificaly iostat and tested the system 
moving a 1G file of random data. I tried going to and from the RAID 
array and a copy on the array.  In general I got 30MB/sec reading and 
11MB/sec writing.  I then phoned Promise and asked what I should expect 
and they said I was on the mark.  They also commented the SX6000 is not 
really a performance oriented card: I am glad they were honest.

We will probably use the array for storage. People will move the GIS 
data to some 75G SCSI drives to do batch processing or other work.  I am 
also going to put a fast large SATA or EIDE disk in as a hog disk, where 
I can spool/buffer backups before they hit the SCSI tapes.

My only real complaint with the card is the high load averages that I 
get when working the array. I would say if I copy 120G from EIDE to the 
array my load average is 1.5-1.7 for the duration of the copy (3 hours 
at 11M/sec). This is if the system is doing nothing else. I know this is 
not all the arrays fault, after all I am using the an IDE channel. But I 
do get a high load everage when doing a copy/move on the array.   Some 
times the load average can be higher. But the system seems fairly resposive.

I just read a message from somone with a 3Ware card who complaind of 
similar concerns.  Speaking of which, I phoned the people at 3Ware to 
ask what I would get with an Escilade card and they were not much 
better.  Probably about 40M/sec they said but would not be as specific 
as Promise.

I find reiserfs works well on the array. I have another RAID5 array that 
does not have the hot-spare drive (to be replaced with the 2nd one I am 
working on) that has not lost a byte of data.   When I created the array 
I used the 64K stripe block size.  I suppose I could go smaller, and 
perhaps save some space but I have very few small files. Most are 1MB or 
more.  The people at Promise were not optimistic that I would get any 
better performance with a different block size: given the i/o stats I am 
getting.  In retrospect I might have gone with a 32K stripe block size, 
or at least tested it.  But at 12h to initialize the array, I did not 
have an extra day.

All in all I do find you get what you pay for.  I bet an SATA 3Ware card 
would be much better, but I don't really want to swap out perfectly good 
drives. I may as well get a few more fast SCSI or SATA disk for people 
to do work on. Speaking of drives, I find the WD2000 drives run quite 
HOT.  I'm probably going to add some more ventilation. If you drop the 
temperature of your drives by only a few degrees you stand to 
significantly increase their life expectancy.

J.

