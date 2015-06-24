From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Wed, 24 Jun 2015 07:02:36 -0400
Message-ID: <wrfj616dtlmb.fsf@redhat.com>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
	<20150624175556.701b724c@noble>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150624175556.701b724c@noble> (NeilBrown's message of "Wed, 24
	Jun 2015 17:55:56 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Tue, 23 Jun 2015 20:26:12 -0400
> Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Neil,
>> 
>> I have been hitting issues with discard being ridiculously slow on
>> arrays with certain typs of SSDs that seem to serialize discard
>> processing.
>> 
>> This is particularly bad as I have seen systems where the IMSM BIOS
>> defaults to 4KB chunk size, combined with these badly performing
>> drives, it could bump the mkfs on an array from seconds to over 40
>> minutes. Most users will stick to the defaults and then hit the
>> problem during install without understanding why it goes wrong :(
>> 
>> The problem is that there is no way to benchmark our way to this or
>> somehow test if a drive performs discard at reasonable speed. I
>> suggest we take an approach similar to that of RAID456 and default to
>> disabling discard, except for the case where the user knows the drives
>> are safe.
>> 
>> Thoughts?
>> 
>> Cheers,
>> Jes
>> 
>> Jes Sorensen (1):
>>   raid0: Disable discard per default due to performance uncertainty
>> 
>>  drivers/md/raid0.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>
> RAID1?  RAID0??  I hate it when I do that!
>
> Doesn't the scheduler merge adjacent discard requests?
>
> Or is this some non-SATA/SCSI SSD that has a 'make_request_fn' driver?
> I think I came across one of those before (NVMe).
> In that case - the driver needs to be fixed.

Nope the block layer doesn't merge the requests at this point. It
actually triggered an OOM on my test system, which has only 4GB of RAM,
because discard commands are not handled as normal commands and have no
control on how many outstanding commands are in flight.

Jes
