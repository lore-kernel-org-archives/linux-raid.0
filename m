From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 13:15:43 +1000
Message-ID: <20130612131543.1c79e077@notabene.brown>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com>
	<yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	<yq1d2s1rcb7.fsf@sermon.lab.mkp.net>
	<51AE2A8C.4080508@zytor.com>
	<yq18v2prbum.fsf@sermon.lab.mkp.net>
	<CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
	<51AE3441.3000208@zytor.com>
	<CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
	<51AEA4FE.3060900@zytor.com>
	<yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
	<20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
	<yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
	<20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/snLE73m/W_sJmZRpuRLfJfT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/snLE73m/W_sJmZRpuRLfJfT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Jun 2013 10:15:05 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> A few outstanding questions that I have, maybe Neil or someone more
> familiar with the code could answer.
>=20
> Q1 - Is mddev->chunk_sectors is always zero for RAID1?

Not always.  But often.  It is largely ignored.  I think the only effect is
to round the size of the device down to a multiple of the chunk size.

>=20
> Q2 - I noticed handle_write_finished calls narrow_write_error to try and
>      potentially avoid failing an entire device.  In my tests,
>      narrow_write_error never succeeded as rdev->badblocks.shift =3D -1.

Yes.  You would need a newer mdadm (from my git tree) to get badblocks.shift
to something else.

>=20
>      I think this part of the bad block list code Neil has been working
>      on.  I don't suppose this is the proper place for MD to reset
>      write_same_max_bytes to disable future WRITE SAME and handling the
>      individual writes here instead of the block layer?

If a drive reports that WRITE SAME works, but it doesn't, then I'm not sure
that I can be happy about working with that drive.
If a drive has some quirky behaviour wrt WRITE SAME, then that should be
handled in some place where 'quirks' are handled - certainly not in md.


I've applied that patch below - thanks.

NeilBrown


>=20
> Regards,
>=20
> -- Joe
>=20
>=20
> From b12c24ee0fce802f35263da65d236694b01c99cf Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Fri, 7 Jun 2013 15:25:54 -0400
> Subject: [PATCH] raid1: properly set blk_queue_max_write_same_sectors
>=20
> MD RAID1 chunk_sectors will always be zero, unlike RAID0, so RAID1 does
> not need to worry about limiting the write same sectors in that regard.
> Let disk_stack_limits choose the minimum of the RAID1 components write
> same values.
>=20
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/md/raid1.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fd86b37..3dc9ad6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2821,9 +2821,6 @@ static int run(struct mddev *mddev)
>  	if (IS_ERR(conf))
>  		return PTR_ERR(conf);
> =20
> -	if (mddev->queue)
> -		blk_queue_max_write_same_sectors(mddev->queue,
> -						 mddev->chunk_sectors);
>  	rdev_for_each(rdev, mddev) {
>  		if (!mddev->gendisk)
>  			continue;


--Sig_/snLE73m/W_sJmZRpuRLfJfT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbfn3znsnt1WYoG5AQIKQg/6AgjNIvGFIkP9HYBiKpSp0ubPfm4uqwoP
RCtrF4XXibxOTFs9yMP1nKhtjD8NEy62+FtvJ1O/nlhDaVYx8bypGSOMhgEbkPS8
u0gjI/LfWQcdnSqowhICqj/nlRhXWFuXW1m+ykWCpJmvzU8zGIcPagNFzu9HQjGG
kFWBbmy1ImkoBavu7G1KbRjjZraFDY8S7glMGX+IjLRjWu/3XTrrvmXcvDgib6im
BSKuvkv/cS/8f2+fgVSkAPqc8HqjjCmy1w0u0L8ZO8fonO42eW8j0wEeeF1H3rqS
9yOGT2TvVDbGeQOxKDSsGMumXjLJ60/HFgmKd++B+1aALKv7mxaJbwsaDD1Iamhz
YLKBeyz4/kWfsIq63CUOjJcIcOpSvw5x/ERMY9Jfyl6LwUYsB7bVqzuAKNgezj1w
Y+tYC9zY/cHSjeD2l5Hk8AGsyw8d5oraml6GIJtJzSqd+vFt9YYwWs+A87zfmOR+
8xsXNsjYaBz+jlw/OUBuoojw5XNkjWJ+JtcfEorNm1VQJOqdZ9WosK2EA3odZEXi
O54m6pxwfkXamFbxkK46UTQGJKuX8+ssf+lgCV3CefSTDr3CvNcEbEA/STFbZ//y
TEKw8rJULzOA4f+Z5oamo+70wkX23a2zFpCKPV0aH0znztGEZBXe4dODGn/j1V2y
R6XpysWfAco=
=Pz1Q
-----END PGP SIGNATURE-----

--Sig_/snLE73m/W_sJmZRpuRLfJfT--
