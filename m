From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 01:53:11 +0100
Message-ID: <20080130005311.GA12717@rap.rap.dk>
References: <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk> <479FC5B6.10308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479FC5B6.10308@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 06:32:54PM -0600, Moshe Yudkowsky wrote:
> 
> >Hmm, why would you put swap on a raid10? I would in a production
> >environment always put it on separate swap partitions, possibly a number,
> >given that a number of drives are available.
> 
> In a production server, however, I'd use swap on RAID in order to 
> prevent server downtime if a disk fails -- a suddenly bad swap can 
> easily (will absolutely?) cause the server to crash (even though you can 
> boot the server up again afterwards on the surviving swap partitions).

I see. Which file system type would be good for this?
I normally use XFS but maybe other FS is better, given that swap is used
very randomly 8read/write).

Will a bad swap crash the system?

best regards
keld
