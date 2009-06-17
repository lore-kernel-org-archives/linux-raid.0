From: Raz <raziebe@gmail.com>
Subject: Re: Subject:[PATCH 001:013]: md: Raid0 reshape
Date: Wed, 17 Jun 2009 11:23:48 +0300
Message-ID: <5d96567b0906170123q2fad427bu37526f3692b0f0f6@mail.gmail.com>
References: <1245189112.3478.94.camel@raz> <20090617081238.GB6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090617081238.GB6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Andre. Please see inline.
I really tried to minimize md patch.

On Wed, Jun 17, 2009 at 11:12 AM, Andre Noll<maan@systemlinux.org> wrot=
e:
> On 00:51, raz ben yehuda wrote:
>> md assumes that personality has all its membes of the same
>> size,A fact that is incorrect for raid0.
>>
>> =A0md.c | =A0 11 +++++++++--
>> =A01 file changed, 9 insertions(+), 2 deletions(-)
>>
>> Signed-off-by: razb <raziebe@gmail.com>
>> ---
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 0f11fd1..e14fb90 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5683,7 +5683,8 @@ static void status_resync(struct seq_file *seq=
, mddev_t * mddev)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_sectors =3D mddev->resync_max_sector=
s;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_sectors =3D mddev->dev_sectors;
>> -
>> + =A0 =A0 if (mddev->level =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 max_sectors =3D mddev->resync_max_sectors;
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Should not happen.
>> =A0 =A0 =A0 =A0*/
>> @@ -6280,7 +6281,13 @@ void md_do_sync(mddev_t *mddev)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->recovery_o=
ffset < j)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 j =3D rd=
ev->recovery_offset;
>> =A0 =A0 =A0 }
>> -
>> + =A0 =A0 /*
>> + =A0 =A0 * raid0 members may not be of the same size,use array_size=
=2E
>> + =A0 =A0 */
>> + =A0 =A0 if (mddev->level =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 max_sectors =3D mddev->array_sectors;
>> + =A0 =A0 =A0 =A0 =A0 =A0 j =3D mddev->recovery_cp;
>> + =A0 =A0 }
>> =A0 =A0 =A0 printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdna=
me(mddev));
>> =A0 =A0 =A0 printk(KERN_INFO "md: minimum _guaranteed_ =A0speed:"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 " %d KB/sec/disk.\n", speed_min(mddev));
>
> Hm, we want to get rid of personality-dependent code in md.c, so new
> code should never check mddev->level. In the first hunk I think it
> would be possible to check if pers->sync_request is NULL.
No. sync_request does exists. this is what Neil wanted me to do.
implement raid0_sync
so I will be using md for this purpose. I knew that md patch is a
problem, this is why I posted
it first.
> Is the second hunk really necessary? AFAICS md_do_sync() won't be
> called for raid0 anyway.
second hunk is necessary for resume reshape. md_do_sync is called
indirecrly by raid0d -->md_check_recovery.

> Regards
> Andre
> --
> The only person who always got his work done by Friday was Robinson C=
rusoe
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iD8DBQFKOKV2Wto1QDEAkw8RAtweAJ9Zub5oTgEFomNsPQUAY4onGnZzDACfdkD1
> WxZ1hdqoMz4p+BNQ8uH5+PY=3D
> =3Dtxka
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
