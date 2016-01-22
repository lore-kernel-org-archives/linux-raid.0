From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 17:23:05 -0600
Message-ID: <CACsGCyQXdwdqfKnKt73ZP_A3k91T-Hi386dhDitC7zAB6f+6Qw@mail.gmail.com>
References: <56A26E11.2090703@yandex.ru>
	<56A28309.9080806@turmel.org>
	<56A2A2C3.9000801@yandex.ru>
	<56A2AAB1.6070305@turmel.org>
	<56A2B223.7060804@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2B223.7060804@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 22, 2016 at 4:50 PM, Dark Penguin <darkpenguin@yandex.ru> wrote:
>> the recommended timeout for 'C' has drifted upward to 180.
>
> Yes, I saw this; but, is it really not possible to examine the default
> timeout in a certain desktop drive, rather than follow rough estimates like
> "about two of three minutes should be enough"?

When I asked something similar in
https://www.marc.info/?l=linux-raid&m=144666581206186&w=2 the answers
I got

https://www.marc.info/?l=linux-raid&m=144666614306348&w=2
https://www.marc.info/?l=linux-raid&m=144666776906740&w=2

indicated that you just need the kernel timeout to be longer than the
disk timeout.  *Anything* longer is good.  It just has to be longer.
You want the *disk* to return a complaint.  You don't want the driver
to time out before the disk has had the opportunity to complain.  The
point of setting SCTERC to 7 seconds is to force the *drive* (not
kernel) to give up quickly and complain.  That'll force a rebuild,
rewriting the sector in question and remapping the bad sector on the
drive with the failure.  (If I've misunderstood this hopefully someone
much more expert will correct me!)  If you can't configure the drive
to give up quickly on a read error, then your remaining alternative is
to tell the kernel to wait (effectively) forever (180 sec) to allow
the drive enough time to give up on its own.

Regarding disabling scrubbing, I'd say that even with disabled SCTERC
(TL;DR haha) and bad default timeouts, it's still better for the array
to fail right away when you only have a single bad sector on a single
drive.  If you let it wait, you run the risk of developing a bad
sector on another drive, so that when you hit the first bad sector
through usage and the drive fails and you trigger a rebuild, you hit
the bad sector on the other drive and *bam* you're toast.

               Eddie
