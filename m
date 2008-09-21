From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Add support for data integrity to MD
Date: Sat, 20 Sep 2008 22:01:29 -0400
Message-ID: <yq1ljxmmf46.fsf@sermon.lab.mkp.net>
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
	<e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com> (Dan Williams's message of "Sat\, 20 Sep 2008 17\:26\:40 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Dan" == Dan Williams <dan.j.williams@gmail.com> writes:

>> + /* Data integrity passthrough not supported on RAID 4, 5 and 6 */
>> + if (pers->level >= 4 && pers->level <= 6) + return 0;

Dan> Do you have a reference to the issues in supporting this?

Not really.

The protection information is an extra 8-bytes of stuff per sector.
But it comes down in a different buffer.  To do R-M-W effectively
we'll have to maintain a separate protection information stripe cache.
And we'll have to generate DIF checksums and reference tags for the
parity sectors going out.

Quite frankly it's a lot of ick and I haven't completely wrapped my
head around it yet.

-- 
Martin K. Petersen	Oracle Linux Engineering

