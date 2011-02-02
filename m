From: hansbkk@gmail.com
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 23:48:12 +0700
Message-ID: <AANLkTinvurdEuDFcXycrf=5qoZwEjxSc2izf8e0dgQAq@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
	<20110202144726.GB18517@cthulhu.home.robinhill.me.uk>
	<iic0k1$950$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iic0k1$950$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 11:24 PM, David Brown <david@westcontrol.com> wrote:
> Of course, there is a cost - if you have 15 2TB drives, with one being a
> warm spare shared amongst the raid1 pairs, you have only 6 x 2TB storage.

Please correct me if I got the math (or anything else) wrong.

If one didn't implement RAID5 (rather just using RAID0 or LVM) over
the RAID1s, and were OK with the 6x2TB usable space out of 15 drives,
then you'd have three spares (actually hot spares right?), allowing
for *any four* drives to fail (but still as long as it wasn't a
matched pair within the _much shorter_ rebuild time window.)

While a RAID6+spare, where any three can fail (and unlike the above
any two can fail within the (admittedly longer) rebuild window, gives
*double* the usable space - 12x2TB.
