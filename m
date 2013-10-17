From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Thu, 17 Oct 2013 21:58:27 +1100
Message-ID: <20131017215827.6a85d2bc@notabene.brown>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914203800.385466b2@notabene.brown>
	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>
	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
	<5234CA6A.3070305@arcor.de>
	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
	<52373A19.7000105@arcor.de>
	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>
	<523C8EF9.60809@arcor.de>
	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com>
	<CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
	<52409E62.3090105@arcor.de>
	<CAC9WiBigzwNFV2FSU+tWS969fh+6G6ikQcrDqDyW0CbiaOuLkQ@mail.gmail.com>
	<CAC9WiBje39ij9RLEqe8aha3FGn_LirxzQezXx-s5+J-HqUpwug@mail.gmail.com>
	<524C6711.3090805@arcor.de>
	<20131016155711.715678e7@notabene.brown>
	<CAC9WiBiwSHTC6o2sXwjqyy78B07VCgkdJG5PpHGyYu8bNV4JvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BAr0VYkK/zSu/7R7pLMahJG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiwSHTC6o2sXwjqyy78B07VCgkdJG5PpHGyYu8bNV4JvA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BAr0VYkK/zSu/7R7pLMahJG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 22:10:54 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hi Neil,
>=20
> On Wed, Oct 16, 2013 at 6:57 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 02 Oct 2013 20:33:53 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> >
> >> On 09/27/2013 05:47 PM, Francis Moreau wrote:
> >>
> >> > I finally found my issue: mdmon --takeover service wasn't started
> >> > anymore (probably I messed it up earlier). Therefore mdmon started by
> >> > initrd was used and wasn't working properly.
> >>
> >> Thanks a lot for finding this out, glad your system is working again.
> >> And sorry for having lost you and talking about the BIOS; I was thinki=
ng
> >> you were still working on fake BIOS hardware.
> >>
> >> > If you still want me to test something, please tell me.
> >> >
> >> > OTHO, it would be easier if you setup a git tree somewhere with your
> >> > patches that you want me to test. BTW I'm not subscribed to linux-ra=
id
> >> > mailing list.
> >>
> >> I'll wait for Neil to come back and comment on my patches. It doesn't
> >> make sense for me right now to create my own repository.
> >
> > Hi,
> >  I'm back from leave now :-)
> >  Your patches look good - thanks a lots.
> >  I think I have applied them all (though the numbering was a bit odd an=
d I
> >  might have missed something).
> >
> >  I've lost track ... are there any outstanding issues here, or are we "=
done" ?
> >
>=20
> I think there's still one open issue when sequence numbers don't match du=
ring
> incremental assembly.
>=20
> Martin started addressing this in another new thread whose subject is
> "RFC: incremental container assembly when sequence numbers don't
> match"
>=20
>
Ah yes, thanks.  I had a quick look and it seems to make sense, but it
deserves more thorough consideration.
I'll get on to that sometime soon.

Thanks,
NeilBrown

--Sig_/BAr0VYkK/zSu/7R7pLMahJG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl/C0znsnt1WYoG5AQLYjg//Z7bWAh7LNa+Fu8+Oi1+hyWZVR/0xWSX+
Cy7nm1l59T26yU0PGmJ07gZgqewJEx88Dib1SFI+juA/eDzPScDdLnUtRuPjoKnV
AxHR0thoAxGa6GV5Sn8nHHFOzfaWZm90f7nsEICvjeaNUn0nxuLhRKr2r6La+x8G
yutUR0qJLENda9bC3RKY9KqkSR+SDoZVruKX99rrKuEy9VLrpwqsKADE+s+OYpry
CFgiW3C9dOF6md/Ql3D6HHAIqBM7DYLZI7tD5PvyL2G/ldn3MMnrCIb4Ey6k43ed
00zxS3Fe9sqM5U5etOp1Egm+qN/J7QU2uPc8n7tg1DEe4wDeK0UIW2zGPmihO9uP
I6fbpzymawFcraO4Wp3aAJd8QP6eKCGszMvVfNeBeTzUR6PKHDxb2TUr2HJCrKhl
VEzgB293LHzWgys/Msnb2cR39bOB1DyQsnn8M0/ww0+lly7mQ0bEBRJSMWoK3vsU
lJmOkAttpPfON5tDI4M1kKZ5axeTuegrFgQRRiTtLkuRIlMcdrcTkqlDXOgq6cDe
FwwOLGHuHb7oGC7A7n63gV/dGf26qQmMdEnO7P0OrlmviabLwZtdT+INw5Ew6c1b
/yQBb0XeUBMB3ZdMhR9SBRCvlGmr4dWYzBf+jOJdJ6Eq9CWvT5WRybJCq++0BkSx
MGZhRl5IFW4=
=nnkF
-----END PGP SIGNATURE-----

--Sig_/BAr0VYkK/zSu/7R7pLMahJG--
