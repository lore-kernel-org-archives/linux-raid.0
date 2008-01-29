From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 21:21:56 +0100
Message-ID: <20080129202156.GA32434@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F7FCD.7030106@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 01:34:37PM -0600, Moshe Yudkowsky wrote:
> 
> I'm going to convert back to the RAID 1 setup I had before for /boot, 2 
> hot and 2 spare across four drives. No, that's wrong: 4 hot makes the 
> most sense.
> 
> And given that RAID 10 doesn't seem to confer (for me, as far as I can 
> tell) advantages in speed or reliability -- or the ability to mount just 
> one surviving disk of a mirrored pair -- over RAID 5, I think I'll 
> convert back to RAID 5, put in a hot spare, and do regular backups (as 
> always). Oh, and use reiserfs with data=journal.

Hmm, my idea was to use a raid10,f2 4 disk raid for the /root, or a o2
layout. I think it would offer quite some speed advantage over raid5. 
At least I had on a 4 disk raid5 only a random performance of about 130
MB/s while the raid10 gave 180-200 MB/s. Also sequential read was
significantly faster on raid10. I do think I can get about 320 MB/s 
on the raid10,f2, but I need to have a bigger power supply to support my
disks before I can go on testing. The key here is bigger readahead.
I only got 150 MB/s for raid5 sequential reads. 

I think the sequential read could be significant in the boot time,
and then for the single user running on the system, namely the system
administrator (=me), even under reasonable load.

I would be interested if you would experiment with this wrt boot time,
for example the difference between /root on a raid5, raid10,f2 and raid10,o2.



> Comments back:
> 
> Mr. Tokarev wrote:
> 
> >By the way, on all our systems I use small (256Mb for small-software 
> >systems,
> >sometimes 512M, but 1G should be sufficient) partition for a root 
> >filesystem
> >(/etc, /bin, /sbin, /lib, and /boot), and put it on a raid1 on all...
> >... doing [it]
> >this way, you always have all the tools necessary to repair a damaged 
> >system
> >even in case your raid didn't start, or you forgot where your root disk is
> >etc etc.
> 
> An excellent idea. I was going to put just /boot on the RAID 1, but 
> there's no reason why I can't add a bit more room and put them all 
> there. (Because I was having so much fun on the install, I'm using 4GB 
> that I was going to use for swap space to mount base install and I'm 
> working from their to build the RAID. Same idea.)

If you put more than /boot on the raid1, then you will not get the added
performance of raid10 for all your system utilities. 

I am not sure about redundance, but a raid1 and a raid10 should be
equally vulnerable to a 1 disk faliure. If you use a 4 disk raid1 for 
/root, then of cause you can survive 3 disk crashes.

I am not sure that 4 disks in a raid1 for /root give added performance, 
as grub only sees the /root raid1 as a normal disk, but maybe some kind of
remounting makes it get its raid behaviour.


> >Also, placing /dev on a tmpfs helps alot to minimize number of writes
> >necessary for root fs.

I thought of using the noatime mount option for /root.

best regards
Keld
