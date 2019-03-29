From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 1/3] Don't jump to compute_result state from check_result
 state
Date: Fri, 29 Mar 2019 18:11:59 +0000
Message-ID: <4E82467A-B5D3-45B7-A394-C23F9E35C3E1@fb.com>
References: <20190329174617.3670341-1-songliubraving@fb.com>
 <20190329174617.3670341-2-songliubraving@fb.com>
 <97dc86ee-b9d6-152e-ba5a-b485ac6a3fde@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <97dc86ee-b9d6-152e-ba5a-b485ac6a3fde@kernel.dk>
Content-Language: en-US
Content-ID: <FB21C3E4747C56449E03380328D2BAAC@namprd15.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid <linux-raid@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "neilb@suse.com" <neilb@suse.com>, "xni@redhat.com" <xni@redhat.com>, "ncroxon@redhat.com" <ncroxon@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, David Jeffy <djeffery@redhat.com>
List-Id: linux-raid.ids



> On Mar 29, 2019, at 10:51 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 3/29/19 11:46 AM, Song Liu wrote:
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index c033bfcb209e..4204a972ecf2 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4223,26 +4223,15 @@ static void handle_parity_checks6(struct r5conf =
*conf, struct stripe_head *sh,
>> 	case check_state_check_result:
>> 		sh->check_state =3D check_state_idle;
>>=20
>> +		if (s->failed > 1)           =20
>> +		    break;
>=20
> Not sure what happened here, but there's a lot of whitespace after that
> if statement, and the break is using 4 spaces instead of a tab. I fixed
> both of these up, but please review the style of patches going forward.
>=20
> --=20
> Jens Axboe
>=20

Thanks Jens! I will be more careful in the future.=20

Song=
