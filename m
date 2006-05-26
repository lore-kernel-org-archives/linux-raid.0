From: Nix <nix@esperi.org.uk>
Subject: Re: Does software RAID take advantage of SMP, or 64 bit CPU(s)?
Date: Fri, 26 May 2006 01:14:50 +0100
Message-ID: <874pzd1w1x.fsf@hades.wkstn.nix>
References: <4472A9FF.9060501@comcast.net>
	<17522.43808.68998.902497@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.43808.68998.902497@cse.unsw.edu.au> (Neil Brown's message of "23 May 2006 07:27:17 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 May 2006, Neil Brown noted:
> On Monday May 22, talbotx@comcast.net wrote:
>> A few simple questions about the 2.6.16+ kernel and software RAID.
>> Does software RAID in the 2.6.16 kernel take advantage of SMP?
> 
> Not exactly.  RAID5/6 tends to use just one cpu for parity
> calculations, but that frees up other cpus for doing other important
> work.

To expand on this, that depends on how many RAID arrays you've got,
since there's one parity-computation daemon per array.

If you have several arrays and are writing to them at the same time,
or several arrays and some are degraded, then several md*_raid*
daemons might be working at once.

But that's not very likely, I'd guess. (I have multiple RAID-5 arrays,
but that's only because I'm trying to get useful RAIDing on multiple
disks of drastically different size.)

-- 
`On a scale of 1-10, X's "brokenness rating" is 1.1, but that's only
 because bringing Windows into the picture rescaled "brokenness" by
 a factor of 10.' --- Peter da Silva
