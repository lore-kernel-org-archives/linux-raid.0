From: Roman Gushchin <klamm@yandex-team.ru>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Thu, 29 Oct 2015 17:15:48 +0300
Message-ID: <30651446128148@webcorp02d.yandex-team.ru>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru> <87r3kebjgx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87r3kebjgx.fsf@notabene.neil.brown.name>
Sender: stable-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-raid.ids

29.10.2015, 03:35, "Neil Brown" <neilb@suse.de>:
> On Wed, Oct 28 2015, Roman Gushchin wrote:
>
>> =9AAfter commit 566c09c53455 ("raid5: relieve lock contention in get=
_active_stripe()")
>> =9A__find_stripe() is called under conf->hash_locks + hash.
>> =9ABut handle_stripe_clean_event() calls remove_hash() under
>> =9Aconf->device_lock.
>>
>> =9AUnder some cirscumstances the hash chain can be circuited,
>> =9Aand we get an infinite loop with disabled interrupts and locked h=
ash
>> =9Alock in __find_stripe(). This leads to hard lockup on multiple CP=
Us
>> =9Aand following system crash.
>>
>> =9AI was able to reproduce this behavior on raid6 over 6 ssd disks.
>> =9AThe devices_handle_discard_safely option should be set to enable =
trim
>> =9Asupport. The following script was used:
>>
>> =9Afor i in `seq 1 32`; do
>> =9A=9A=9A=9A=9Add if=3D/dev/zero of=3Dlarge$i bs=3D10M count=3D100 &
>> =9Adone
>>
>> =9ASigned-off-by: Roman Gushchin <klamm@yandex-team.ru>
>> =9ACc: Neil Brown <neilb@suse.de>
>> =9ACc: Shaohua Li <shli@kernel.org>
>> =9ACc: linux-raid@vger.kernel.org
>> =9ACc: <stable@vger.kernel.org> # 3.10 - 3.19
>
> Hi Roman,
> =9Athanks for reporting this and providing a fix.
>
> I'm a bit confused by that stable range: 3.10 - 3.19
>
> The commit you identify as introducing the bug was added in 3.13, so
> presumably 3.10, 3.11, 3.12 are not affected.

Sure, it's my mistake. Correct range is 3.13 - 3.19. Sorry.

> Also the bug is still present in mainline, so 4.0, 4.1, 4.2 are also
> affected, though the patch needs to be revised a bit for 4.1 and late=
r.

Yes, exactly, but things are a bit more complicated in mainline.
I'll try to prepare a patch for mainline in a couple of days.

Thanks,
Roman
