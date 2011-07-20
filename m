From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Wed, 20 Jul 2011 14:20:08 +0200
Message-ID: <j06h5o$ebm$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org> <j03m2p$jn1$1@dough.gmane.org> <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk> <j0613g$aoe$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0613g$aoe$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2011 09:42 AM, David Brown wrote:
>> http://tdm27.wordpress.com/2011/07/19/some-solid-state-drive-benchmarks/
>
> The telling figure here, though, is that TRIM made the single drive significantly slower.

More precisely, online-TRIM of ext4 on Intel SSDs seems to be a bad combination.

I think it's clear you cannot gain much from TRIM if you're willing to spend
the money for 2 times overprovisioning, anyway. You can lose significantly from
online-trim when the filesystem issues a lot of TRIM commands all the time and
when the SSD is slow to process them.

TRIM gains you an advantage with less over-provisioning, and is better
done in batches after significant amounts of data have been written/deleted.

When you try with different levels of over-provisioning, also try with
batched discards (fstrim) between runs of your benchmark.

Regards,

Lutz Vieweg


