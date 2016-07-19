From: Phil Turmel <philip@turmel.org>
Subject: Re: Cannot start array on disk
Date: Tue, 19 Jul 2016 05:12:06 -0400
Message-ID: <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com>
 <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bhatia Amit <amitbhatia@rocketmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/17/2016 03:59 PM, Bhatia Amit wrote:
> Hi
> 
> I have a WD Live duo setup with two 3TB drives in RAID1. After a
> recent power surge etc, I could not access the enclosure data. I
> removed the drives out from the enclosure and connected them via
> esata cable to a Linux laptop. One of the drives had physical noise
> and failed to connect at all. The other drive was able to connect and
> showed up as /dev/sdc. Following some online search, I issued the
> following commands to get some results, but am unable to mount the
> drive to a linux laptop via esata. Questions:
> 
> * Ideally both sdc3 and sdc4 should have shown RAID=RAID1. If sdc4 is
> showing RAID=linear, is it because the other drive went totally bad,
> and software decided to reconfigure this drive from RAID1 to linear
> ?

No way to know.  I would be inclined to believe that that you didn't
actually have raid1 set for those partitions.  Do you recall the
available space in that device while running?

> * Given the one of the two drives is totally dead, is it still
> possible to reconfigure, mount and recover data from the single
> drive?

If truly linear, no, not past the half-way mark.  The device is
identified as role 0, so it would be the beginning of the filesystem in
a linear array.  If it really was raid1 with v0.9 or v1.0 metadata, you
can mount /dev/sdc4 directly to access your data.  That it doesn't show
a detected filesystem suggests that it wasn't raid1.

Even worse, that partition shows a creation date and update date both in
2013, with no events.  Suggesting that the device hasn't actually been
running properly in the array since its initial creation.

> * I tried scanning the drive via r-linux and it does show files
> exist, but does not show any folder information. So data is there on
> the drive. Is there a way to recreate the setup with just this single
> drive, so that I can extract files with folder information?

With v1.0 metadata, you should be able to fsck /dev/sdc4 and then mount.
 Kinda dangerous though -- I suggest you use an overlay for that.  I
suspect that sdc4 hasn't been running in your array for the past three
years.

> * Looking at an online "derrick" script, the script seems to call
> mdadm create with the "missing" flag. Is that something I should be
> doing to be able to assemble and recover data from the drive ?

> "mdadm --create $rootfsRaid --verbose --metadata=0.9 --raid-devices=2
> --level=raid1 --run $diskRoot1 missing"

No.

Using --create is practically never the right solution, unless you've
done operations that destroy the right solution.  Metadata v0.9 is
almost certainly wrong.

If you have syslogs on your other array that show the boot details from
the last successful boot *before* it died, that might provide the
details needed to figure if anything recent is on sdc4.

Phil
