From: Andrew Morton <akpm@osdl.org>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Sun, 17 Dec 2006 03:05:39 -0800
Message-ID: <20061217030539.a7ac1a68.akpm@osdl.org>
References: <20061204203410.6152efec.akpm@osdl.org>
	<200612161056.26830.rjw@sisk.pl>
	<200612161216.07669.rjw@sisk.pl>
	<200612171200.13075.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200612171200.13075.rjw@sisk.pl>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <ltuikov@yahoo.com>
List-Id: linux-raid.ids

On Sun, 17 Dec 2006 12:00:12 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Okay, I have identified the patch that causes the problem to appear, which is
> 
> fix-sense-key-medium-error-processing-and-retry.patch
> 
> With this patch reverted -rc1-mm1 is happily running on my test box.

That was rather unexpected.   Thanks.
