From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when
 stopping
Date: Wed, 17 Feb 2016 08:03:22 +0100
Message-ID: <56C41B3A.90902@suse.de>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
 <1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
 <wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com>
 <56C36D20.6030001@suse.de> <wrfja8n0bi8n.fsf@redhat.com>
 <8737sstmbh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737sstmbh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/16/2016 09:46 PM, NeilBrown wrote:
> On Wed, Feb 17 2016, Jes Sorensen wrote:
>=20
>> Hannes Reinecke <hare@suse.de> writes:
>>> On 02/16/2016 07:03 PM, Sebastian Parschauer wrote:
>>>> On 16.02.2016 18:41, Jes Sorensen wrote:
>>>>> Sebastian Parschauer
>>>>> <sebastian.riemer@profitbricks.com> writes:
>>>>>> When stopping an MD device, then its device node
>>>>>> /dev/mdX may still exist afterwards or it is
>>>>>> recreated by udev. The next open() call can lead to
>>>>>> creation of an inoperable MD device. The reason for=20
>>>>>> this is that a change event (KOBJ_CHANGE) is
>>>>>> announced to udev. So announce a removal event
>>>>>> (KOBJ_REMOVE) to udev instead.
>>>>>>=20
>>>>>> This also overrides the change event sent by the
>>>>>> kernel.
>>>>>>=20
>>>>>> Signed-off-by: Sebastian Parschauer
>>>>>> <sebastian.riemer@profitbricks.com> --- Manage.c |
>>>>>> 6 +++--- 1 file changed, 3 insertions(+), 3
>>>>>> deletions(-)
>>>>>>=20
>>>>>> diff --git a/Manage.c b/Manage.c index
>>>>>> 7e1b94b..bc89764 100644 --- a/Manage.c +++
>>>>>> b/Manage.c @@ -494,13 +494,13 @@ done: goto out; } /*
>>>>>> prior to 2.6.28, KOBJ_CHANGE was not sent when an md
>>>>>> array -	 * was stopped, so We'll do it here just to
>>>>>> be sure.  Drop any -	 * partitions as well... +	 *
>>>>>> was stopped, it should be KOBJ_REMOVE instead, so we
>>>>>> set the +	 * remove event here just to be sure. Drop
>>>>>> any partitions as well... */ if (fd >=3D 0) ioctl(fd,
>>>>>> BLKRRPART, 0); if (mdi) -		sysfs_uevent(mdi,
>>>>>> "change"); +		sysfs_uevent(mdi, "remove");
>>>>>=20
>>>>> I am a little concerned about this change. You assume
>>>>> the kernel and mdadm will be updated in sync, which is
>>>>> unlikely to happen. I believe you need to match the
>>>>> kernel version and send the corresponding event=20
>>>>> currectly for this to work correctly?
>>>>=20
>>>> The worst thing that can happen is that the kernel sends
>>>> the change event after the remove event. Then it is the
>>>> current situation again. From my tests mdadm does enough
>>>> other stuff in between. Udev is able to handle receiving
>>>> two remove events from my testing. Multiple mdadm=20
>>>> instances can't run in parallel any ways. So userspace
>>>> around it needs some serialization for it any ways. So
>>>> also stopping an MD device and assembling a new one with
>>>> the same minor number shouldn't race.
>>>>=20
>>>> I still prefer this solution here. But if you decide to
>>>> drop the udev event sending in mdadm, then I'm also fine
>>>> with that.
>>>>=20
>>> I strongly prefer removing the udev event generation
>>> altogether. As this appears to be a carry-over from older
>>> kernels, it looks to me as being an incomplete conversion:=20
>>> At one point udev introduced 'ONLINE' and 'OFFLINE' events,
>>> which were supposed to be used for this kind of scenario.=20
>>> (ONLINE being a companion to 'ADD', and 'OFFLINE' being the
>>> companion to 'DELETE'). However, later the 'ONLINE' got
>>> modified to 'CHANGE', and the 'OFFLINE' got dropped
>>> completely. Or that was the plan. So it looks as if the
>>> conversion to 'CHANGE' got applied to the 'OFFLINE' event,
>>> too. Hence I strongly recommend to drop it completely, and
>>> let the kernel or the MD module decide if and when a uevent
>>> should be send.
>>=20
>> I am totally fine with this, however we should make mdadm
>> fail if run against a pre-2.6.28 kernel then.
>>=20
>> Cheers, Jes
>=20
> I would suggest protecting the
>=20
> if (fd >=3D 0) ioctl(fd, BLKRRPART, 0); if (mdi)=20
> sysfs_uevent(mdi, "change");
>=20
> code with
>=20
> if (get_linux_version() < 2006028)
>=20
> That should be completely safe - 2.6.28 and later do this (if
> needed).
>=20
+1.

Yes, this is the best solution.

Cheers,

Hannes
- --=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWxBs6AAoJEGz4yi9OyKjP8a0P/RqXuKmFFOcBXnST1f1ZWq24
gExfzeo8VAQicWi/CBFu+lumePOiypzKfP0NfHw4PDGPYuLQQq6OXRmiQCqhWz/p
EBRZ9a8NyUIjUpra2j66IiMGwh1KGYl9AeIZmvGTNVkNcOySKdJxLWkFnI6wLwvU
YmUez04UFxEleynt5c00ZYvioYnVchVDNEc4/8yTG6jAUg4+6Q7tTw8vvR3wko+K
vmDbUyUz+q8R5tyTjCKB/KWgMPnMUv+wYoZx+jWtpRyUO6a76U9T5if+ZKk4EUkb
NBHy76L6/YxvOhJqAuX9dMiPDADgHVzD5mnzTSzt9HF/ArXBXtEMcaMxhLPYpLTU
lY7FQqzQ5sGQKbo0nm3EHrLjIP1bWe3BKaniyFQG39wlzdhhFGCzJzHnl1KwSnu6
gy+/AuQSibvxUQhD/ZO4+AJjMq1sXLwRlwwPFr/pI8wrcIqFIUuZG0JjY9NY2UQ2
+povgSj4UnXpRS7BKjvmN/VyUIbnXzf8cpB8w2qwxI5nSwKgjhSNz+o3NeCDQqpw
u2E0MIciPDKXb2GnfPA2+Depm8VfcL9uaRNbHmnV9shIlRsQLB9/IzzVA5Cf5T3f
GA9pHLKEM2LHAWqPmUVIghzyTTj5CXsZrH2GdJVyNTc1bymDBKmQbbiO+IVIHg45
XnJ7L15O6ZTXEW1WMNYT
=3DokXv
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
