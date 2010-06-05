From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sat, 5 Jun 2010 18:56:31 -0500
Message-ID: <6B.E5.17309.334EA0C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinbN9-ne0ySKq-GRGLiIhHopH_a-vtysx7yjmob@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinbN9-ne0ySKq-GRGLiIhHopH_a-vtysx7yjmob@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Carlos Mennens' <carloswill@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > =A0 =A0 =A0 =A0It's certainly workable. =A0You might consider somet=
hing other than
> > RAID1 for your swap partition.
>=20
> Looks reasonable. Some comments:
>=20
> 1) I didn't bother using RAID on my /boot. I just installed grub on
> each of the 3 drives but only boot from the first one. If that
> partition goes bad I can boot from the second or third drive any time
> by just telling BIOS to use a different drive. This saves me from
> dealing with any mkinitrd stuff. I've never had a boot partition go
> bad because of the drive itself in 14 years running Linux. They go ba=
d
> because I write the wrong stuff there. RAID doesn't solve that
> problem. This method does require that I update the two backups by
> hand once in awhile. That's OK by me.

	Define, "once in awhile [sic]".  It's certainly possible to do it,
but the very reason I went with boot arrays rather than boot partitions=
 was
it was getting to be a pain to update the backup drives all the time.
Almost every time a package is added or deleted, /etc gets updated.  Ke=
eping
different copies of the configuration files in /etc in the initrd and t=
he
root partition is not the best of ideas, although if course it can be d=
one.
Any package which must be available at boot *MUST* update initrd, and i=
f
most distro packages are anything, it is update rich.

> 2) I don't use RAID for swap. I let the kernel do that internally. I
> almost never swap out on my home server so trying to protect that wit=
h
> RAID for the few moments I might use it seems like overkill to me.

	I halfway agree.  My servers almost never use any significant amount
of swap, and even my workstations only use it very occasionally.  There=
 have
been instances, however, where the swap has grown to be quite large.  W=
ith
that in mind, and given the very small amount he has allocated for swap=
, one
might suggest a RAID0 array of the areas to be used for swap, or maybe =
an
LVM volume.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
