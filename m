From: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Subject: RE: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Tue, 8 May 2012 09:59:58 +0000
Message-ID: <679865E03F4C71419D9847EA3AACB163157D4CE6@IRSMSX102.ger.corp.intel.com>
References: <20120316073213.656519005@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120316073213.656519005@fusionio.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Shaohua Li
> Sent: Friday, March 16, 2012 8:32 AM
> To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
> Cc: neilb@suse.de; axboe@kernel.dk; vgoyal@redhat.com;
> martin.petersen@oracle.com
> Subject: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
> 
> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM
> support for raid 4/5/6 later. The implementation is pretty
> straightforward and self-explained.
> 
> v1->v2:
> 1. fixed a checking issue
> 2. dropped discard request plug and replace it with no discard merege,
> because current SCSI layer can't handle discard request merge.
> 
> Thanks,
> Shaohua

Hi,
Can't see anywhere patch 2/6 from this series.


maciej
