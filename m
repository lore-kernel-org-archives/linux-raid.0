From: thunder7@xs4all.nl
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Sun, 17 Dec 2006 17:00:56 +0100
Message-ID: <20061217160056.GA3555@amd64.of.nowhere>
References: <20061204203410.6152efec.akpm@osdl.org> <200612161056.26830.rjw@sisk.pl> <200612161216.07669.rjw@sisk.pl> <200612171200.13075.rjw@sisk.pl> <20061217030539.a7ac1a68.akpm@osdl.org>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061217030539.a7ac1a68.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <ltuikov@yahoo.com>
List-Id: linux-raid.ids

From: Andrew Morton <akpm@osdl.org>
Date: Sun, Dec 17, 2006 at 03:05:39AM -0800
> On Sun, 17 Dec 2006 12:00:12 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Okay, I have identified the patch that causes the problem to appear, which is
> > 
> > fix-sense-key-medium-error-processing-and-retry.patch
> > 
> > With this patch reverted -rc1-mm1 is happily running on my test box.
> 
> That was rather unexpected.   Thanks.
>
I can confirm that 2.6.20-rc1-mm1 with this patch reverted mounts my
raid6 partition without problems. This is x86_64 with SMP.

Kind regards,
Jurriaan
-- 
HORROR FILM WISDOM:
9. If your car runs out of gas at night, do not go to the nearby
deserted-looking house to phone for help.
Debian (Unstable) GNU/Linux 2.6.20-rc1 2x2011 bogomips load 7.42
the Jack Vance Integral Edition: http://www.integralarchive.org
