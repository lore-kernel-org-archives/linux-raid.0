From: Keld Simonsen <keld@keldix.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 03:04:20 +0200
Message-ID: <20100606010420.GA26325@rap.rap.dk>
References: <AANLkTinbN9-ne0ySKq-GRGLiIhHopH_a-vtysx7yjmob@mail.gmail.com>
 <6B.E5.17309.334EA0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6B.E5.17309.334EA0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Mark Knecht' <markknecht@gmail.com>, 'Carlos Mennens' <carloswill@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jun 05, 2010 at 06:56:31PM -0500, Leslie Rhorer wrote:
> > > =A0 =A0 =A0 =A0It's certainly workable. =A0You might consider som=
ething other than
> > > RAID1 for your swap partition.
> >=20
> > Looks reasonable. Some comments:
> >=20
>=20
> > 2) I don't use RAID for swap. I let the kernel do that internally. =
I
> > almost never swap out on my home server so trying to protect that w=
ith
> > RAID for the few moments I might use it seems like overkill to me.
>=20
> 	I halfway agree.  My servers almost never use any significant amount
> of swap, and even my workstations only use it very occasionally.  The=
re have
> been instances, however, where the swap has grown to be quite large. =
 With
> that in mind, and given the very small amount he has allocated for sw=
ap, one
> might suggest a RAID0 array of the areas to be used for swap, or mayb=
e an
> LVM volume.

If you use some mirrored RAID for swap, your system will continue to ru=
n, if
one of your disks go bad. Then you can replace the faulty disk at a lat=
er,
and possibly more convenient time.

If you do not have RAID, your system will most likely go down, if the s=
wap partiion
is damaged.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
