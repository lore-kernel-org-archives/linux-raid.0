From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 16:21:56 +0100
Message-ID: <20080130152156.GA22131@rap.rap.dk>
References: <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk> <47A07D95.2030902@msgid.tls.msk.ru> <47A08E02.3000009@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A08E02.3000009@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 30, 2008 at 03:47:30PM +0100, Peter Rabbitson wrote:
> Michael Tokarev wrote:
> 
> >With 5-drive linux raid10:
> >
> >   A  B  C  D  E
> >   0  0  1  1  2
> >   2  3  3  4  4
> >   5  5  6  6  7
> >   7  8  8  9  9
> >  10 10 11 11 12
> >   ...
> >
> >A&B can't be removed - 0, 5.  A&C CAN be removed, as
> >are A&D.  But not A&E - losing 2 and 7.  And so on.

I see. Does the kernel code allow this? And mdadm?

And can B+E be removed safely, and C+E and B+D? 

best regards
keld
