From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
Date: Thu, 22 Mar 2012 10:33:50 +0800
Message-ID: <CANejiEVqPVJ_Rcx60287ypgJg0CBTqX+ozQR-y3jK=UY+SosXg@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<yq1d385wf75.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d385wf75.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

2012/3/22 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:
>
> Shaohua> Enabling discard merge is required for device with slow discard
> Shaohua> (and very helpful for raid),
>
> Before RAID support there really wasn't much point. That's one of the
> reasons the current discard merge code has survived despite being
> completely broken.
Exactly.

> As for how I'd like to handle contiguous discard merges going forward
> here's a proof of concept. It's on top of my write same tree so you may
> have to noodle a bit.
>
> It is crucially important that we never merge a command that can't be
> processed by the device. So I'd like to do something like this:
This is great to consolidate the check with this patch. But looks this
isn't enough. As far as I know the current discard merge is broken
because blk_update_request() can't handle such request because
we override the first BIO to add payload. I had a quick hack and post
out yesterday. It works in my SATA ssd, but I really didn't know if there
is something missing in SCSI side, can you share anything here?

Thanks,
Shaohua
