From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 00/17] mdadm: SCSI enclosure based array
Date: Wed, 16 Dec 2015 21:49:31 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104BD5B25@PRN-MBX02-4.TheFacebook.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
 <87d1u7b188.fsf@notabene.neil.brown.name>
 <CAPcyv4g47ZUZfCEeLRtwZkXudArRVRyFLar4RrDg1iM=kjK6iQ@mail.gmail.com>
 <87h9ji9ivl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h9ji9ivl.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

> So "by-path" is about the data-path that leads to the device, but "by-slot" is
> about the physical location of the device (which may correlate with the path,
> but is conceptually different).  I guess I can accept that.
> I don't suppose "by-location" was considered?
> Can a "disk" have other locations that "slots"?
> I guess 'sd' cards live in slots.
> But USB sticks plug into sockets (or are sockets just slots?) CDROMs live in trays.
> 
> Is there some convention for naming slots?
>   enclosure-rank-row-column ??
> Is there some convention for naming enclosures?  Bob, Jane, Ahmed?

The enclosure:slots name comes from SCSI Enclosure Service (SES) definitions, 
and it is just enclosure-slot (no rank, row, column). 

Here, we use the SAS address of the SCSI Enclosure Processor (SEP) to identify 
the enclosure, while the slot is just numbers. For example:

enclosure-0x570e2840203080ff-slot0 -> /dev/sdl
enclosure-0x570e2840203080ff-slot1 -> /dev/sdj
enclosure-0x570e2840203080ff-slot10 -> /dev/sdk

At this time, this concept only applies to drives in SCSI enclosure. Other drives
do not have this symlink. 

Thanks,
Song
