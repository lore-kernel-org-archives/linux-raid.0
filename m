From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 07:14:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107180711490.20159@uplift.swm.pp.se>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E235984.2070704@5t9.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 17 Jul 2011, Lutz Vieweg wrote:

> David Brown wrote:
>> However, AFAIUI, you are wrong about TRIM being essential for the continued 
>> high performance of SSDs.  As long as your SSDs have some over-provisioning 
>> (or you only partition something like 90% of the drive), and it's got good 
>> garbage collection, then TRIM will have minimal effect.
>
> I beg to differ.
>
> Of course, you can only benefit from discards if your filesystem
> is not full (because then there is nothing to discard). But any
> kind of "garbage collection" by the SSD itself will not have the
> same effect, since it cannot know which blocks are in use by the
> filesystem.

Well, that's what you gain from only using 90% of the drive space for data 
(be it via partition or some other means), you increase the 
overprovisioning and thus the drive has more empty space to play with, 
even if you fill up the FS to 100%.

So yes, TRIM is nice but if you want consistant performance then you need 
to assume that your FS is going to be 100% full anyway, so then you have 
to limit the FS block use to 80-90% of the total drive space.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
