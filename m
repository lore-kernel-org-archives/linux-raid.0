From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/6] Enable create array with write journal
 (--write-journal DEVICE).
Date: Tue, 6 Oct 2015 11:32:05 -0700
Message-ID: <CAPcyv4g8b=RS7um6KzpmfrEtF1WaC2DF050gDNdA7MxP6mh-nw@mail.gmail.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
	<1440804426-1461372-4-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-4-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Aug 28, 2015 at 4:27 PM, Song Liu <songliubraving@fb.com> wrote:
> Specify the write journal device with --write-journal DEVICE
>
> ./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-journal /dev/sdb1
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
>
> Only one journal device is allowed. If multiple --write-journal
> are given, mdadm will use the first and ignore others
>
> ./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-journal /dev/sdb1 --write-journal /dev/sdx
> mdadm: Please specify only one journal device for the array.
> mdadm: Ignoring --write-journal /dev/sdx...
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.

Hmm, perhaps this should instead follow the same command line
mechanics as "--write-mostly" whereby all the devices listed after
that flag take on that role.  Also, if we anticipate more roles I
wonder if the option should be "--role=" that assigns the given role
to the device(s) that follow.

Thoughts?

I'm looking at this from the perspective of reviving the SRT patches
[1] where a role for a read/write cache device is needed.  Where a
read/write-cache is different than a journal.

[1]: https://lwn.net/Articles/596614/
