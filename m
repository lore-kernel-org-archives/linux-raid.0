From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: Re: RFC: handling of missing disks in DDF
Date: Thu, 08 Aug 2013 10:47:57 +0200
Message-ID: <52035B3D.30706@ts.fujitsu.com>
References: <5202B633.3080807@arcor.de> <20130808090423.4b806828@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130808090423.4b806828@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/08/2013 01:04 AM, NeilBrown wrote:
> On Wed, 07 Aug 2013 23:03:47 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> 
>> Hi Neil, everyone,
>>
>> I'd like to get comments on the following concept for handling missing
>> disks. Currently we handle "Missing" and "Failed" almost equally, that's
>> not optimal.
>>
>> 1. Try to detect missing disks and mark them so in the meta data.
>> ddf_open_new() could do this. At the latest, it must be done before
>> writing the meta data (write_super or sync_metadata).
>>
>> 2. Detection of a missing disk should not force an immediate meta data
>> write, because the disk may be added soon. It's sufficient to mark a
>> disk as missing when we write the meta data for other reasons.
>>
>> 3. Try to be smart when loading headers. A disk that was missing in a
>> previous run must have a lower seq number and time stamp in the meta
>> data than the other disks, and must be marked "Missing" there (but not
>> "Failed"). The meta data on the preciously missing disk should mark it
>> as "active/Online". In this case, use the newer meta data, and try to
>> re-integrate the previously missing disk (i.e. treat it as preferred
>> global spare).
>>
>> 4. It's possible that an array wasn't written to while a disk had been
>> missing. In that case the disk could be re-added to the array without
>> recovery. The question is if we can detect this situation. I thought
>> first  the "Not Consistent" bit might be usable for that, but I doubt it
>> now. The spec isn't clear about whether "consistent" state means
>> consistency over all configured disks or only over present ones.
>>
> 
> Hi Martin.
> Thanks for looking into this.
> 
> Can you say why exactly that treating 'Missing' like 'Failed' is not
> optimal?  I find them to be very similar concepts.

The DDF spec says that "Failed" means a disk on which (a certain number
of) IO errors were observed. "Missing" may be a disk that simply wasn't
present during boot (or wasn't included during container assembly, for
that matter).

When a missing but otherwise healthy disk reappears, it makes sense to
use it as a spare. This is obviously not right for a failed disk. Thus
it is important to distinguish "Failed|Missing" from "Missing" alone.

There is a large grey zone - a disk may be missing because of IO errors
during device detection. A real-life reason for "missing" disks may be
fabric problems e.g. for iSCSI targets or FC targets. More often than
not, these targets work just fine after the network problem was fixed.
Admittedly, if the fabric problems occur during RAID operation, MD has
no way to tell fabric from disk problems and must mark the disk as "Failed".

> Your idea for marking a missing device that reappears as a preferred spare is
> probably a good one - is that incompatible with treating it as failed while
> it isn't present?
> 
> As soon as we mark an array as active (aka Not Consistent) we need to mark
> any missing devices as 'failed' in some way to ensure that the data is never
> seen as valid in the array.  Before that we can certainly be lazy about
> translating 'missing' to 'failed'...

Unfortunately that won't work - "Failed" indicates observed IO errors.
Interpreting "Missing|Failed" as "missing in an active array" would
break these semantics.

> Maybe if you could give some more detail on the problem scenario??

The most likely scenario would be with networked storage.
IMSM seems to have some very specific semantics for disks missing at
container creation time that I don't fully understand (see
tests/09imsm-assemble).

Martin

> 
> Thanks,
> NeilBrown
> 


-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
