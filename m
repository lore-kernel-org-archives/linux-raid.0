From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
Date: Tue, 23 Jan 2007 15:48:03 +0300
Message-ID: <45B60403.1060201@tls.msk.ru>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru> <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> On Tue, 23 Jan 2007, Michael Tokarev wrote:
> 
>> Disabling pre-emption on critical and/or server machines seems to be a good
>> idea in the first place.  IMHO anyway.. ;)
>
> So bottom line is make sure not to use preemption on servers or else you 
> will get weird spinlock/deadlocks on RAID devices--GOOD To know!

This is not a reason.  The reason is that preemption usually works worse
on servers, esp. high-loaded servers - the more often you interrupt a
(kernel) work, the more nedleess context switches you'll have, and the
more slow the whole thing works.

Another point is that with preemption enabled, we have more chances to
hit one or another bug somewhere.  Those bugs should be found and fixed
for sure, but important servers/data isn't a place usually for bughunting.

/mjt
