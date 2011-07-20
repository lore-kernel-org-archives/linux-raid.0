From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Wed, 20 Jul 2011 09:42:55 +0200
Message-ID: <j0613g$aoe$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org> <j03m2p$jn1$1@dough.gmane.org> <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/07/2011 16:19, Tom De Mulder wrote:
>
> In case people are interested, I ran more benchmarks. The impact of TRIM
> on an over-provisioned drive is remarkable: a 25% performance loss when
> using Postmark.
>
> Because this isn't really on-topic for the MD mailing list, I've put it
> somewhere else:
>

It is a little off-topic, perhaps, but still of interest to many RAID 
users precisely because of the myths and inaccurate data surrounding 
TRIM.  There are too many people that think TRIM is essential to SSD's, 
RAID doesn't support TRIM, therefore you shouldn't use RAID and SSD's 
together.

> http://tdm27.wordpress.com/2011/07/19/some-solid-state-drive-benchmarks/
>

To try to explain your results - first it's easy to see why md raid1 
with discard is a little slower than md raid1 without discard - the raid 
layer ignores the discards, so they can't help or hinder much, and the 
filesystem is doing a bit of extra work (sending the discards) to no 
purpose.

It is also easy to see why a single SSD with no discards is about the 
same speed.  You are using RAID1 - reads and writes are not striped in 
any way, so the speed is the same as for a single disk.  If the test 
accessed multiple files in parallel (especially reads), you'd see faster 
reads.

The telling figure here, though, is that TRIM made the single drive 
significantly slower.

> My next goal, when I have the time, is to compare different amounts of
> over-provisioning.
>

Also try using RAID10,far for your arrays.  That will work the SSD's 
harder, and perhaps give a better comparison.

