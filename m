From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 22:15:31 +0200
Message-ID: <20080715201531.GC26439@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <487CEF1A.6050402@wasp.net.au> <487CF499.6080105@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487CF499.6080105@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Brad Campbell <brad@wasp.net.au>, Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 01:03:53PM -0600, Maurice Hilarius wrote:
> Brad Campbell wrote:
> >Do you have some pointers for information on motherboards that come 
> >with hardware raid? I'd be interested to have a look at them. I've 
> >certainly seen plenty of "fakeraid" systems, but I've not yet come 
> >across hardware raid on an MB.
> >
> >Brad
> Quite a few server boards now offer the LSI RAID SAS chips.
> Most only do RAID 0,1,10 ( not 5 or 6)

It is my impression that many users want to employ raid, for safety, and
possibly speed. A popular choice is raid1. And there I would like to
advocate people to use raid10.

It looks like mobo raid1 is easier to use, tho.

Best regards
keld
