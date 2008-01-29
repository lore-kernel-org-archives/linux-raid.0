From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:51:24 +0100
Message-ID: <20080129175124.GA19527@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F4941.1050304@rabbit.us> <479F597B.9050105@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F597B.9050105@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 07:51:07PM +0300, Michael Tokarev wrote:
> Peter Rabbitson wrote:
> []
> > However if you want to be so anal about names and specifications: md
> > raid 10 is not a _full_ 1+0 implementation. Consider the textbook
> > scenario with 4 drives:
> > 
> > (A mirroring B) striped with (C mirroring D)
> > 
> > When only drives A and C are present, md raid 10 with near offset will
> > not start, whereas "standard" RAID 1+0 is expected to keep clunking away.
> 
> Ugh.  Yes. offset is linux extension.
> 
> But md raid 10 with default, n2 (without offset), configuration will behave
> exactly like in "classic" docs.

I would like to understand this fully. What Peter described for mdraid10:
" md raid 10 with near offset " I believe is vanilla raid10 without any
options (or near=2, far=1). Will that not start if we are unlucky to
have 2 drives failing, but we are lucky that the data on the two
remaining drives actually have all the data?

Same question for a raid10,f2 array. I think it would be easy to
investigate, when the number of drives are even, if all data is present,
and then happily run an array with some failing disks.

Say for a 4 drive raid10,f2 disks A and D are failing, then all data
should be present on drives B and C, given that A and C have the even
chunks, and B and D have the odd chunks. Likewise for a 6 drive array,
etc for all multiples of 2, with F2.

best regards
keld
