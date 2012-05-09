From: Shaohua Li <shli@fusionio.com>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Wed, 9 May 2012 10:27:14 +0800
Message-ID: <CANejiEUnrFkJwtQocZ3PjmHX_DMKZD1825Or7=RT7H-cYb2Vug@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<679865E03F4C71419D9847EA3AACB163157D4CE6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB163157D4CE6@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

2012/5/8 Patelczyk, Maciej <maciej.patelczyk@intel.com>:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Shaohua Li
>> Sent: Friday, March 16, 2012 8:32 AM
>> To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
>> Cc: neilb@suse.de; axboe@kernel.dk; vgoyal@redhat.com;
>> martin.petersen@oracle.com
>> Subject: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
>>
>> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM
>> support for raid 4/5/6 later. The implementation is pretty
>> straightforward and self-explained.
>>
>> v1->v2:
>> 1. fixed a checking issue
>> 2. dropped discard request plug and replace it with no discard merege,
>> because current SCSI layer can't handle discard request merge.
>>
>> Thanks,
>> Shaohua
>
> Hi,
> Can't see anywhere patch 2/6 from this series.
http://marc.info/?l=linux-kernel&m=133188350823292&w=2

Thanks,
Shaohua
