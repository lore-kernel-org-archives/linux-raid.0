From: Hannes Reinecke <hare@suse.de>
Subject: Re: [md PATCH 0/9] replace printk() with pr_*()
Date: Wed, 2 Nov 2016 13:36:21 +0100
Message-ID: <5cd6d570-6d72-07b4-34a4-5b75503fcbf4@suse.de>
References: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147805657658.23566.1748253447749986766.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/02/2016 04:16 AM, NeilBrown wrote:
> This series removes all printk() calls from md code, preferring
> pr_warn(), pr_err() etc.
>
> All strings that were split over multiple lines are not joined
> back together because being able to search for a message is more
> important that not having long lines in the code.
> Lots of printk(KERN_DEBUG... are not pr_debug() which means the
> messages won't get printed unless they are explicitly disabled.
>
> I included some rough guidelines on which pr_* to choose in md.c.
> Many things became pr_debug(), most of the rest are pr_warn().
> pr_err() and pr_crit() are used sparingly.
>
> I simplified some code in multipath.c too.
>
> A particular benefit of this is that the various "print_conf()"
> functions are not silent by default.
> On very large arrays (raid10 with hundreds of devices), these can
> be very noisy.
>
Any specify reason why you didn't move to use dev_*() style of errors?
Generally I prefer having the messages prefixed with the device which 
caused them; making debugging _so_ much easier ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
