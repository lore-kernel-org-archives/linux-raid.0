From: NeilBrown <nfbrown@novell.com>
Subject: Re: Reshape stuck immediately, backup file all nulls
Date: Thu, 11 Feb 2016 15:22:15 +1100
Message-ID: <8760xvx4eg.fsf@notabene.neil.brown.name>
References: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com> <56ACEE63.6070108@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56ACEE63.6070108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, =?utf-8?Q?Bj=C3=B6rn?= Augustsson <oggust@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 31 2016, Phil Turmel wrote:

> Hi Bj=C3=B6rn,
>
> On 01/30/2016 07:21 AM, Bj=C3=B6rn Augustsson wrote:
>
>> The question is, what kind of state am in now?=20
>
> The kernel is waiting for mdmon (mdadm as a background task) to step
> through the stripes.  mdmon died and the kernel will wait forever.

Close, not quite.

'mdmon' is a background task that mdadm *only* uses for externally
managed metadata: IMSM and DDF.

For a reshape like this mdadm needs a background "mdadm" task.  It used
to just fork, but in these enlightened days it asks systemd to run that
task.
As has already been observed, that failed due to selinux not
understanding.

So it was an 'mdadm' which exited, rather than an mdmon which died...

Maybe you already worked that out.

The days of backup files should be numbered.  New kernels and new mdadm
adjust the data-offset so no back is needed.  In that case, no
background mdadm is needed either.

NeilBrown


>
>> And how should I recover?
>> Will just adding a policy to allow access to that file, and then
>> mdadm --grow --continue /dev/md127
>> fix it?=20
>
> Probably.  Others have fixed this by disabling selinux for the reshape.
>  Don't forget to specify --backup-file again on the command line.  (I
> don't use selinux myself, so I can't be more specific.)
>
> In the future, consider not using a backup file at all -- mdadm
> generally leaves enough dead space on devices to avoid the need.
>
>> Is the broken backup file going to be a problem?
>
> Shouldn't be. Report back if it is.
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWvAx3AAoJEDnsnt1WYoG5BFsP+QHM5WigN1+rCTfwYE6MkkkC
b1BYH1NKElR1U/fRaQqZ9n7mEQcW++Fi/7rx7sEHH8OzXoFjxpAnbMlUPaulp2v/
oybiTab8vTzCg82D/Uy5+MBxSknl/7TQvCWc9dBTo0MEWleC1lpr0gEju43XtZDp
61sUQ7jdCcL8pYszPJgXyiOTCMMpJ3KSQXlL/yTwcpYAYK1s4Ax+fNYsStBf1mvV
7v1VAR9PBSqJk20cLPdbt7XpQ1YFJT9HquhfGzbQ3w9cu8cJh44mnqoPLvFk9AS9
xYJbv1DxTKkB4T0sIdkuZAEROs5ec+QYLRKefq5isDFlvRmzDc35tWW/7Rgzcghy
dZRuyULkP/csH4lyFL6uoVrqP4sK6uUU2ModQtLugWoo47oW6K2L1lhCnwyYuRah
O5gQiUQs02bpuD85IULS8SUtLQvVD53yYsqDmT0m3PHAXCTdumQ7Zh0hNA1rQ2W7
ITLXrt1dzykriqzyMbEBDmCrL1tVJLJ4sojuoA/IF66NN8byNcO63bKt2DjLt4N1
OTkXGWFOfO8JahMDMgDFsGY/cpettLJOMfMDWWsAfP5dInzjraIV6SKQR6IzbqRf
Zkqc8703LHKYF1LppkVQ4sx70TywkVmYk6nnkPZkory9xUynIWJfaTy/X03wfpLo
1dYEymHod8rr08+ijDOu
=3+4t
-----END PGP SIGNATURE-----
--=-=-=--
