From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid1 - mismatches after resuming interrupted recovery
Date: Fri, 30 Oct 2015 14:07:23 -0400
Message-ID: <wrfjmvv0mdr8.fsf@carbonite.lan.trained-monkey.org>
References: <559AAAAA.2030904@stratus.com>
	<wrfj1tccpcuc.fsf@carbonite.lan.trained-monkey.org>
	<5633A172.3020804@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5633A172.3020804@stratus.com> (Nate Dailey's message of "Fri, 30
	Oct 2015 12:57:22 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nate Dailey <nate.dailey@stratus.com> writes:
> This is the the same as "ignore recovery_offset if bitmap exists",
> describing how I hit the problem (before attempting to put a patch
> together to fix it).

Thanks for the clarification Nate, I thought it was two different
issues.

Clearly my grey hair is eating away at my brain. Neil please do your
best to ignore me :)

Jes

> On 10/30/2015 11:58 AM, Jes Sorensen wrote:
>> Nate Dailey <nate.dailey@stratus.com> writes:
>>> I've found that if I interrupt a recovery by removing the target
>>> device, do IO before the recovery checkpoint, then re-add the device
>>> and let the recovery complete, the mismatch_cnt is non-zero after
>>> doing a check.
>> Neil,
>>
>> While I am on the nagging path, here is another one.
>>
>> Jes
>>
>>> Here's exactly what I'm doing:
>>>
>>> - create a 5 GB raid1 with internal bitmap
>>>
>>> - do a check, verify zero mismatch_cnt
>>>
>>> - remove one member device
>>>
>>> - dd 256MB with 2GB seek
>>>
>>> - lower sync_speed_min/max to 500
>>>
>>> - re-add removed device
>>>
>>> - wait 15 sec
>>>
>>> - remove the same member device again
>>>
>>> - dd 1MB with 1 GB seek
>>>
>>> - restore sync_speed_min/max to system defaults
>>>
>>> - re-add removed device
>>>
>>> - when recovery competes, do another check
>>>
>>> At this point the mismatch_cnt is non-zero.
>>>
>>>
>>> I originally hit this on RHEL 7.1, but tested 4.1.1 from kernel.org
>>> and it happens there too.
>>>
>>> I'm out of my league in terms of trying to fix this, but would be
>>> happy to test a fix. I wonder if it's really necessary to resume a
>>> bitmap recovery from the checkpoint? Wouldn't the bitmap always
>>> reflect what needs to be copied?
>>>
>>> Nate
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
