From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:26:40 +0100
Message-ID: <20080129162640.GA16250@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F42A5.8040007@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 06:13:41PM +0300, Michael Tokarev wrote:
> 
> Linux raid10 MODULE (which implements that standard raid10
> LEVEL in full) adds some quite.. unusual extensions to that
> standard raid10 LEVEL.  The resulting layout is also called
> raid10 in linux (ie, not giving new names), but it's not that
> raid10 (which is again the same as raid1+0) as commonly known
> in various literature and on the internet.  Yet raid10 module
> fully implements STANDARD raid10 LEVEL.

My understanding is that you can have a linux raid10 of only 2
drives, while the standard RAID 1+0 requires 4 drives, so this is a huge
difference.

I am not sure what vanilla linux raid10 (near=2, far=1)
has of properties. I think it can run with only 1 disk, but I think it
does not have striping capabilities. It would be nice to have more 
info on this, eg in the man page. 

Is there an official web page for mdadm?
And maybe the raid faq could be updated?

best regards
keld 
