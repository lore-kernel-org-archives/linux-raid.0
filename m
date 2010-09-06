From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Mon, 06 Sep 2010 09:43:32 +0200
Message-ID: <4C849BA4.1080106@bfs.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>	<20100905190139.GA3163@merkur.ravnborg.org>	<20100905192335.GA8140@albatros>	<20100905203908.GA3228@merkur.ravnborg.org> <20100906152931.1d4a1d07@notabene>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100906152931.1d4a1d07@notabene>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown schrieb:
> On Sun, 5 Sep 2010 22:39:08 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
>=20
>> On Sun, Sep 05, 2010 at 11:23:35PM +0400, Kulikov Vasiliy wrote:
>>> On Sun, Sep 05, 2010 at 21:01 +0200, Sam Ravnborg wrote:
>>>> On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
>>>>> From: Vasiliy Kulikov <segooon@gmail.com>
>>>>>
>>>>> rcu_dereference() is macro, so it might use its argument twice.
>>>>> Argument must not has side effects.
>>>>>
>>>>> It was found by compiler warning:
>>>>> drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
>>>>> drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=
=80=99 may be undefined
>>>> This change looks wrong.
>>>> In the original implementation new_disk is incremented and
>>>> then we do the array lookup.
>>>> With your implementation it looks like we increment it after
>>>> the array lookup.
>>> No, the original code increments new_disk and then dereferences mir=
rors.
>>>
>>> The full code:
>>>
>>> 		for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
>>> 		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
>>> 		     !rdev || !test_bit(In_sync, &rdev->flags)
>>> 			     || test_bit(WriteMostly, &rdev->flags);
>>> 		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {
>>>
>>> 			if (rdev && test_bit(In_sync, &rdev->flags) &&
>>> 				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
>>> 				wonly_disk =3D new_disk;
>>>
>>> 			if (new_disk =3D=3D conf->raid_disks - 1) {
>>> 				new_disk =3D wonly_disk;
>>> 				break;
>>> 			}
>>> 		}
>>>
>>>     so,
>>>
>>>     for (a; b; c =3D f(++g)) {
>>>        ...
>>>     }=20
>> Thanks - that explains it.
>> This code really screams for a helper function but thats another mat=
ter.
>=20
> Not an uncommon complaint about my code as it happens......
>=20
> I've taken the opportunity to substantially re-write that code.
>=20
> Comments?
>=20
> Thanks,
> NeilBrown
>=20
> commit e4062735c8f7233923df5858ed20f1278f3ee669
> Author: NeilBrown <neilb@suse.de>
> Date:   Mon Sep 6 14:10:08 2010 +1000
>=20
>     md: tidy up device searches in read_balance.
>    =20
>     We have a pre-increment side-effect in the arg to a macro:
>       rcu_dereference
>    =20
>     This is poor form and triggers a warning.  Rather than just fix t=
hat,
>     take the opportunity to re-write the code it make it more readabl=
e.
>    =20
>     Reported-by: Kulikov Vasiliy <segooon@gmail.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ad83a4d..e29e13f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -420,11 +420,13 @@ static void raid1_end_write_request(struct bio =
*bio, int error)
>  static int read_balance(conf_t *conf, r1bio_t *r1_bio)
>  {
>  	const sector_t this_sector =3D r1_bio->sector;
> -	int new_disk =3D conf->last_used, disk =3D new_disk;
> -	int wonly_disk =3D -1;
> +	int new_disk =3D -1;
> +	int start_disk;
> +	int i;
>  	const int sectors =3D r1_bio->sectors;
>  	sector_t new_distance, current_distance;
>  	mdk_rdev_t *rdev;
> +	int choose_first;
> =20
>  	rcu_read_lock();
>  	/*
> @@ -435,54 +437,35 @@ static int read_balance(conf_t *conf, r1bio_t *=
r1_bio)
>   retry:
>  	if (conf->mddev->recovery_cp < MaxSector &&
>  	    (this_sector + sectors >=3D conf->next_resync)) {
> -		/* Choose the first operational device, for consistancy */
> -		new_disk =3D 0;
> -
> -		for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
> -		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
> -		     !rdev || !test_bit(In_sync, &rdev->flags)
> -			     || test_bit(WriteMostly, &rdev->flags);
> -		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> -
> -			if (rdev && test_bit(In_sync, &rdev->flags) &&
> -				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
> -				wonly_disk =3D new_disk;
> -
> -			if (new_disk =3D=3D conf->raid_disks - 1) {
> -				new_disk =3D wonly_disk;
> -				break;
> -			}
> -		}
> -		goto rb_out;
> +		choose_first =3D 1;
> +		start_disk =3D 0;
> +	} else {
> +		choose_first =3D 0;
> +		start_disk =3D conf->last_used;
>  	}
> =20


perhaps you can drop the else when you init with
choose_first =3D 0;
start_disk =3D conf->last_used;



> -
>  	/* make sure the disk is operational */
> -	for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
> -	     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
> -	     !rdev || !test_bit(In_sync, &rdev->flags) ||
> -		     test_bit(WriteMostly, &rdev->flags);
> -	     rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev)) {
> -
> -		if (rdev && test_bit(In_sync, &rdev->flags) &&
> -		    r1_bio->bios[new_disk] !=3D IO_BLOCKED)
> -			wonly_disk =3D new_disk;
> -
> -		if (new_disk <=3D 0)
> -			new_disk =3D conf->raid_disks;
> -		new_disk--;
> -		if (new_disk =3D=3D disk) {
> -			new_disk =3D wonly_disk;
> -			break;
> +	for (i =3D 0 ; i < conf->raid_disks ; i++) {
> +		int disk =3D start_disk + i;
> +		if (disk >=3D conf->raid_disks)
> +			disk -=3D conf->raid_disks;
> +
> +		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED
> +		    || !(rdev =3D rcu_dereference(conf->mirrors[disk].rdev))
> +		    || !test_bit(In_sync, &rdev->flags))
> +			continue;

i think it is more readable to use:

  rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
  if ()



> +		if (test_bit(WriteMostly, &rdev->flags)) {
> +			new_disk =3D disk;
> +			continue;
>  		}
> +		new_disk =3D disk;
> +		break;
>  	}

to improve readability:

	new_disk =3D disk;
	if ( ! test_bit(WriteMostly, &rdev->flags) )
		break;


> -	if (new_disk < 0)
> +	if (new_disk < 0 || choose_first)
>  		goto rb_out;
> =20
> -	disk =3D new_disk;
> -	/* now disk =3D=3D new_disk =3D=3D starting point for search */
> -
>  	/*
>  	 * Don't change to another disk for sequential reads:
>  	 */
> @@ -491,20 +474,20 @@ static int read_balance(conf_t *conf, r1bio_t *=
r1_bio)
>  	if (this_sector =3D=3D conf->mirrors[new_disk].head_position)
>  		goto rb_out;
> =20
> -	current_distance =3D abs(this_sector - conf->mirrors[disk].head_pos=
ition);
> +	current_distance =3D abs(this_sector=20
> +			       - conf->mirrors[new_disk].head_position);
> =20
> -	/* Find the disk whose head is closest */
> +	/* look for a better disk - i.e. head is closer */
> +	start_disk =3D new_disk;
> +	for (i =3D 1; i < conf->raid_disks; i++) {
> +		int disk =3D start_disk + 1;
> +		if (disk >=3D conf->raid_disks)
> +			disk -=3D conf->raid_disks;
> =20
> -	do {
> -		if (disk <=3D 0)
> -			disk =3D conf->raid_disks;
> -		disk--;
> -
> -		rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
> -
> -		if (!rdev || r1_bio->bios[disk] =3D=3D IO_BLOCKED ||
> -		    !test_bit(In_sync, &rdev->flags) ||
> -		    test_bit(WriteMostly, &rdev->flags))

> +		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED
> +		    || !(rdev =3D rcu_dereference(conf->mirrors[disk].rdev))
> +		    || !test_bit(In_sync, &rdev->flags)
> +		    || test_bit(WriteMostly, &rdev->flags))
>  			continue;

again i would set
 rdev=3Drcu_dereference(conf->mirrors[disk].rdev));
before if() like it was in the original the statement is complex
anything that reduces the complexity is good.


> =20
>  		if (!atomic_read(&rdev->nr_pending)) {
> @@ -516,11 +499,9 @@ static int read_balance(conf_t *conf, r1bio_t *r=
1_bio)
>  			current_distance =3D new_distance;
>  			new_disk =3D disk;
>  		}
> -	} while (disk !=3D conf->last_used);
> +	}
> =20
>   rb_out:
> -
> -
>  	if (new_disk >=3D 0) {
>  		rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
>  		if (!rdev)
>=20


just my 2 cents,
re,
 wh

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-jani=
tors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
