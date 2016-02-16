From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when stopping
Date: Wed, 17 Feb 2016 07:46:58 +1100
Message-ID: <8737sstmbh.fsf@notabene.neil.brown.name>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com> <1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com> <wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com> <56C36D20.6030001@suse.de> <wrfja8n0bi8n.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfja8n0bi8n.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Feb 17 2016, Jes Sorensen wrote:

> Hannes Reinecke <hare@suse.de> writes:
>> On 02/16/2016 07:03 PM, Sebastian Parschauer wrote:
>>> On 16.02.2016 18:41, Jes Sorensen wrote:
>>>> Sebastian Parschauer <sebastian.riemer@profitbricks.com> writes:
>>>>> When stopping an MD device, then its device node /dev/mdX may still
>>>>> exist afterwards or it is recreated by udev. The next open() call
>>>>> can lead to creation of an inoperable MD device. The reason for
>>>>> this is that a change event (KOBJ_CHANGE) is announced to udev.
>>>>> So announce a removal event (KOBJ_REMOVE) to udev instead.
>>>>>
>>>>> This also overrides the change event sent by the kernel.
>>>>>
>>>>> Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
>>>>> ---
>>>>>   Manage.c |    6 +++---
>>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/Manage.c b/Manage.c
>>>>> index 7e1b94b..bc89764 100644
>>>>> --- a/Manage.c
>>>>> +++ b/Manage.c
>>>>> @@ -494,13 +494,13 @@ done:
>>>>>   		goto out;
>>>>>   	}
>>>>>   	/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
>>>>> -	 * was stopped, so We'll do it here just to be sure.  Drop any
>>>>> -	 * partitions as well...
>>>>> +	 * was stopped, it should be KOBJ_REMOVE instead, so we set the
>>>>> +	 * remove event here just to be sure. Drop any partitions as well...
>>>>>   	 */
>>>>>   	if (fd >= 0)
>>>>>   		ioctl(fd, BLKRRPART, 0);
>>>>>   	if (mdi)
>>>>> -		sysfs_uevent(mdi, "change");
>>>>> +		sysfs_uevent(mdi, "remove");
>>>>
>>>> I am a little concerned about this change. You assume the kernel and
>>>> mdadm will be updated in sync, which is unlikely to happen. I believe
>>>> you need to match the kernel version and send the corresponding event
>>>> currectly for this to work correctly?
>>>
>>> The worst thing that can happen is that the kernel sends the change
>>> event after the remove event. Then it is the current situation again.
>>>  From my tests mdadm does enough other stuff in between. Udev is able to
>>> handle receiving two remove events from my testing. Multiple mdadm
>>> instances can't run in parallel any ways. So userspace around it needs
>>> some serialization for it any ways. So also stopping an MD device and
>>> assembling a new one with the same minor number shouldn't race.
>>>
>>> I still prefer this solution here. But if you decide to drop the udev
>>> event sending in mdadm, then I'm also fine with that.
>>>
>> I strongly prefer removing the udev event generation altogether.
>> As this appears to be a carry-over from older kernels, it looks to me
>> as being an incomplete conversion:
>> At one point udev introduced 'ONLINE' and 'OFFLINE' events, which were
>> supposed to be used for this kind of scenario.
>> (ONLINE being a companion to 'ADD', and 'OFFLINE' being the companion
>> to 'DELETE'). However, later the 'ONLINE' got modified to 'CHANGE',
>> and the 'OFFLINE' got dropped completely.
>> Or that was the plan.
>> So it looks as if the conversion to 'CHANGE' got applied to the
>> 'OFFLINE' event, too.
>> Hence I strongly recommend to drop it completely, and let the kernel
>> or the MD module decide if and when a uevent should be send.
>
> I am totally fine with this, however we should make mdadm fail if run
> against a pre-2.6.28 kernel then.
>
> Cheers,
> Jes

I would suggest protecting the

	if (fd >= 0)
		ioctl(fd, BLKRRPART, 0);
	if (mdi)
		sysfs_uevent(mdi, "change");

code with

   if (get_linux_version() < 2006028)

That should be completely safe - 2.6.28 and later do this (if needed).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWw4rCAAoJEDnsnt1WYoG5V8MP/RXiuYa29tTwhqvaSUcJoV+A
IhzrEfoZLnozp7jiG2t1yqvq9gFPzuolbvkt5qZO8tgGotCNn9059EcQNRzLzmbH
WoYRSxiqIGGAfdOGMZI96tGo7tVOEa73lmKN8D80OO5VTBjuD09FquhJ/TvPW17R
VIpHLQqwouknewLjVKoN8lfkVGMwtyNym2uFDNYbKRhG07HJxut6FuFlts7fJHNn
Yzpg4+jOpn6kWRCZcqyi/Y+UGf6ubo1D6igTAX7+8ErnzEOkhUB7SfMJwqiE05Iq
mgKL1Qp5X3eGxQZejcntFGFetwt2NW/vy7F/QtmPTfWmTjz8PR2KaA8LVnIVF/xw
R9xLK2NaYS+Ukhwr758wSLgIsjwAU9EUFCyD2CcB3MPVBoatHEMjKUhI6Qy8DaXI
MSw4tEdyUWCzU7raGsfp9QlMv42LHCuKW8C+nacgKKn+cyQCKLRCKq1GR6cE/s4x
+yV/rSptyV2JOacNlBWmckVgkMeZOW200MNO4mmAHHfDraB3gGjCbYmu5OTn9zKg
qwNf3/kAGyBxk1uu0NOjQdva4Fjs3I+CPj8Q1k1ZEEw9v/p6crcSSw7KPKrjmeYl
5e4gH823nErX7Sym4EadFvmN2DrclEW+LjOd1hqtPOUDD5i8wKcsDkrILzR5zYnG
au0xjyKwBxqdAMrDgBv8
=8mkN
-----END PGP SIGNATURE-----
--=-=-=--
