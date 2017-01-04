From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] raid5: only dispatch IO from raid5d for harddisk raid
Date: Wed, 4 Jan 2017 18:10:59 +0000
Message-ID: <E6506DA7-E269-4092-8761-12FFC1770F82@fb.com>
References: <9e987c0d95c49224da7fb82477dd10fcacf4d794.1483552525.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9e987c0d95c49224da7fb82477dd10fcacf4d794.1483552525.git.shli@fb.com>
Content-Language: en-US
Content-ID: <85ABAFCA752E294CA84F18FD46F8FDB9@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids


> On Jan 4, 2017, at 9:57 AM, Shaohua Li <shli@fb.com> wrote:
>=20
> +	spin_lock_init(&conf->pending_bios_lock);
> +	conf->batch_bio_dispatch =3D true;
> +	rdev_for_each(rdev, mddev) {
> +		if (blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
> +			conf->batch_bio_dispatch =3D false;

Shall we skip this check for the journal device?=20

Song
