From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 2 Aug 2004 14:04:04 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408021403510.26134@lion.drogon.net>
References: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se>
 <200408011633.25028.mrwatts@fast24.co.uk> <Pine.LNX.4.56.0408011806110.6442@lion.drogon.net>
 <200408021354.36804.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408021354.36804.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org, Mark Watts <mrwatts@fast24.co.uk>
List-Id: linux-raid.ids

On Mon, 2 Aug 2004, Mark Watts wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> > On Sun, 1 Aug 2004, Mark Watts wrote:
> > > I'm going to try using xfs instead of ext3 on Monday too.
> >
> > I doubt it's a filesystem issue.
> >
> > Try this - make the array work flat-out - dd into a fil eor something and
> > look at the process state of 'dd'. See if it's stuck in "D".
> >
> > Now look at /proc/interrupts...
> >
> > Look for ERR and MIS counts of non-zero...
>
> Both of those are zero, even when hammering the disks.

Oh well - another good theory up the spout!

Gordon
