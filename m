From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/13] md/raid6: move raid6 data processing to raid6_pq.ko
Date: Sun, 22 Mar 2009 10:22:05 -0700
Message-ID: <e9c3a7c20903221022v6049a74fu89b5032322343f25@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192021.20375.69678.stgit@dwillia2-linux.ch.intel.com>
	 <20090319200931.GA10491@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090319200931.GA10491@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Thu, Mar 19, 2009 at 1:09 PM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On 12:20, Dan Williams wrote:
>> Move the raid6 data processing routines into a standalone module
>> (raid6_pq) to prepare them to be called from async_tx wrappers and o=
ther
>> non-md drivers/modules. =A0This precludes a circular dependency of r=
aid456
>> needing the async modules for data processing while those modules in
>> turn depend on raid456 for the base level synchronous raid6 routines=
=2E
>>
>> To support this move:
>> 1/ The exportable definitions in raid6.h move to include/linux/raid/=
pq.h
>
> As raid*.h and md.h have been moved to drivers/md recently, pq.h
> should probably live there as well.

Not in this case.  pq.h is analogous to xor.h currently in
include/linux/raid/.  I.e. just the data processing symbols that are
used by modules outside of drivers/md/.

>> +#define time_before(x, y) ((x) < (y))
>
> This macro seems to have no users (and a strange name).
>

It's used a few lines down in the same file.  It allows raid6algos.c
to be compiled for the userspace test (drivers/md/raid6test/) where we
do not have jiffies.h.

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
