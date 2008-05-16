From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
Date: Fri, 16 May 2008 20:35:32 +0200
Message-ID: <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com>
References: <482DC043.5000307@dgreaves.com>
	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
	 <482DCCCD.8020503@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <482DCCCD.8020503@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

this[1] patch fixed?

this patch is for 2.6.25.5 kernel

1: http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020

On 5/16/08, David Greaves <david@dgreaves.com> wrote:
>> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
>> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
>> does it work again?
> Yes, no probs.
>
> It came in prior to 2.6.25-rc1
> The machine has a root xfs filesystem with an internal log on a sata disk
> and a
> data filesystem on a partitioned array with an external log (also on the
> partitioned array).
> Only the partitioned array/external-log filesystem is affected.
>
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
