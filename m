From: Phil Turmel <philip@turmel.org>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 19:48:20 -0500
Message-ID: <4D5C7054.10000@turmel.org>
References: <20110216212751.51a294aa@notabene.brown>	<4D5BDB84.8050706@gmail.com>	<20110217082412.51afa2a6@notabene.brown>	<20110217024402.1dd44267@natsu> <20110217085924.01cdf22c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217085924.01cdf22c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 04:59 PM, NeilBrown wrote:
> On Thu, 17 Feb 2011 02:44:02 +0500 Roman Mamedov <rm@romanrm.ru> wrote:
> 
>> On Thu, 17 Feb 2011 08:24:12 +1100
>> NeilBrown <neilb@suse.de> wrote:
>>
>>> "read/write/compare checksum" is not a lot of words so I may well not be
>>> understanding exactly what you mean, but I guess you are suggesting that we
>>> could store (say) a 64bit hash of each 4K block somewhere.
>>> e.g. Use 513 4K blocks to store 512 4K blocks of data with checksums.
>>> When reading a block, read the checksum too and report an error if they
>>> don't match.  When writing the block, calculate and write the checksum too.
>>>
>>> This is already done by the disk drive - I'm not sure what you hope to gain
>>> by doing it in the RAID layer as well.
>>
>> Consider RAID1/RAID10/RAID5/RAID6, where one or more members are returning bad
>> data for some reason (e.g. are failing or have written garbage to disk during
>> a sudden power loss). Having per-block checksums would allow to determine
>> which members have correct data and which do not, and would help the RAID
>> layer recover from that situation in the smartest way possible (with absolutely
>> no loss or corruption of the user data).
>>
> 
> Why do you think that md would be able to reliably write consistent data and
> checksum to a device in a circumstance (power failure) where the hard drive
> is not able to do it itelf?

It wouldn't have to be a power failure.  A kernel panic wouldn't be recoverable,
either.

> i.e. I would need to see a clear threat-model which can cause data corruption
> that the hard drive itself would not be able to reliably report, but that
> checksums provided by md would be able to reliably report.
> Powerfail does not qualify (without sophisticated journalling on the part of
> md).

I agree that the hash itself is insufficient, but I don't think a full journal
is needed either.  If each hash had a timestamp and short sequence number, and
was stored with copies of its siblings' sequence numbers, which data was out of
sync could be worked out.  I admit that quantity of meta-data would be
exhorbitant for 512B sectors, but might be acceptable for 4K blocks.  It does
vary with number of raid devices, though.  I'll have think about ways to
minimize that.

It would work for any situation where data in an MD member device's queue didn't
make it to the platter, and the platter retained the old data.  Of course, if the
number of devices with stale data in one stripe exceeds the failure tolerance
of the array, it still can't be fixed.  The algorithm could *revert* to old data
if the number of devices with new data was within the failure tolerance.  That
might be valuable.

Phil
