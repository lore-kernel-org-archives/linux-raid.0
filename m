From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 data corruption during resync
Date: Tue, 2 Sep 2014 17:14:36 -0500
Message-ID: <73231224-BB78-4485-8D4A-D1EFF0646099@redhat.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com> <EAC50175-42D9-43BA-ADE2-1A50BD0581CB@redhat.com> <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 2, 2014, at 5:07 PM, Eivind Sarto wrote:

>=20
> On Sep 2, 2014, at 12:24 PM, Brassow Jonathan <jbrassow@redhat.com> w=
rote:
>=20
>>=20
>> On Aug 29, 2014, at 2:29 PM, Eivind Sarto wrote:
>>=20
>>> I am seeing occasional data corruption during raid1 resync.
>>> Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc2=
31c9a90a278333c21f761 introduced a bug.
>>> Prior to this commit raise_barrier() used to wait for conf->nr_pend=
ing to become zero.  It no longer does this.
>>> It is not easy to reproduce the corruption, so I wanted to ask abou=
t the following potential fix while I am still testing it.
>>> Once I validate that the fix indeed works, I will post a proper pat=
ch.
>>> Do you have any feedback?
>>>=20
>>> =97 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
>>> +++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
>>> @@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
>>> 	 *    handling.
>>> 	 */
>>> 	wait_event_lock_irq(conf->wait_barrier,
>>> -			    !conf->array_frozen &&
>>> +			    !conf->array_frozen && !conf->nr_pending &&
>>> 			    conf->barrier < RESYNC_DEPTH &&
>>> 			    (conf->start_next_window >=3D
>>> 			     conf->next_resync + RESYNC_SECTORS),
>>=20
>> This patch does not work - at least, it doesn't fix the issues I'm s=
eeing.  My system hangs (in various places, like the resync thread) aft=
er commit 79ef3a8.  When testing this patch, I also added some code to =
dm-raid.c to allow me to print-out some of the variables when I encount=
er a problem.  After applying this patch and printing the variables, I =
see:
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: start_next_window=
 =3D 12288
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: current_window_re=
quests =3D -46
>> 5257
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: next_window_reque=
sts =3D -11562
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_pending =3D 0
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_waiting =3D 0
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_queued  =3D 0
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: barrier =3D 1
>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: array_frozen =3D =
0
>>=20
>> Some of those values look pretty bizarre to me and suggest the accou=
nting is pretty messed up.
>>=20
>> brassow
>>=20
>=20
> After reviewing commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 I not=
ice that wait_barrier() will now only exclude writes.  User reads are n=
ot excluded even if the fall within the resync window.
> The old implementation used to exclude both reads and writes while re=
sync-IO is active.
> Could this be a cause of data corruption?

Not sure yet.  It is also worth mentioning that a follow-on commit (8b5=
92b6) was meant to fix problems with request counting.  I did not have =
that patch applied when I gathered the above info.

 brassow

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
