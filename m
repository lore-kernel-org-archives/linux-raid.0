From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 15:48:40 +0100
Message-ID: <20080129144840.GA4621@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F331F.7080902@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 05:07:27PM +0300, Michael Tokarev wrote:
> Peter Rabbitson wrote:
> > Moshe Yudkowsky wrote:
> >>
> 
> > It is exactly what the names implies - a new kind of RAID :) The setup
> > you describe is not RAID10 it is RAID1+0.
> 
> Raid10 IS RAID1+0 ;)
> It's just that linux raid10 driver can utilize more.. interesting ways
> to lay out the data.

My understandining is that raid10 is different from RAID1+0

Traditional  RAID1+0 is composed of two RAID1's combined into one RAID0.
It takes 4 drives to make it work. Linux raid10 only takes 2 drives to
work.

Traditional RAID1+0 only have one way of laying out the blocks. 

raid10 have a number of ways to do layout, namely the near, far and
offset ways, layout=n2, f2, o2 respectively.

Traditional RAID1+0 can only do striping of half of the disks involved,
while raid10 can do striping on all disks in the far and offset layouts.



I looked around on the net for documentation of this. The first hits (on
Google) for mkadm did not have descriptions of raid10. Wikipedia
describes raid 10 as a synonym for raid1+0. I think there is too much
confusion on the raid10 term, and that also the marveleous linux raid10
layouts is a little known secret beyound maybe the circles of this
linux-raid list. We should tell others more about the wondersi of raid10.

And then I would like a good reference for describing how raid10,o2
works and why bigger chunks work. 

Best regards
keld
