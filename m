From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Tue, 3 Mar 2015 08:43:27 +1100
Message-ID: <20150303084327.21ddb086@notabene.brown>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com>
	<20150219083708.2ab46006@notabene.brown>
	<wrfj61ay6fai.fsf@redhat.com>
	<20150219093236.25660678@notabene.brown>
	<wrfjoaobz7fz.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bsCizfrqr7ek/3.CWJfZNIN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoaobz7fz.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bsCizfrqr7ek/3.CWJfZNIN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Mar 2015 11:32:16 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Wed, 18 Feb 2015 17:11:33 -0500 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> NeilBrown <neilb@suse.de> writes:
> >> > On Wed, 18 Feb 2015 13:12:09 -0500 Jes Sorensen <Jes.Sorensen@redhat=
.com>
> >> > wrote:
> >> >
> >> >> Jes.Sorensen@redhat.com writes:
> >> >> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >> >> >
> >> >> > I have received some issues for when creating an array using a
> >> >> > /dev/mdX name, the matching symlink in /dev/md/X isn't
> >> >> > created. Whereas if you create /dev/md/X, /dev/mdX is created
> >> >> > automatically.
> >> >> >
> >> >> > I was trying to see if there was a better way of dealing with thi=
s,
> >> >> > but I couldn't find one. If you have suggestions for a better sol=
ution
> >> >> > I am all ears.
> >> >> >
> >> >> > Thoughts?
> >> >>=20
> >> >> Hi Neil,
> >> >>=20
> >> >> Any thoughts on this one?
> >> >
> >> > Thanks for the reminder....
> >> >
> >> > I'm not sure that I really see the problem.
> >> >
> >> >   "I ask it to create /dev/mdX and it doesn't create /dev/md/X".
> >> >
> >> > Well ... no.  You didn't ask it to.  If you want it to create /dev/m=
d/X,
> >> > then ... ask it to.
> >> >
> >> > /dev/mdX is the canonical name.  It always gets created.
> >> > /dev/md/X is a convenient alias.  It gets created if requested.
> >> >
> >> > Is there really a problem here worth solving?
> >> >
> >> > Maybe I missed something.
> >>=20
> >> I have had complaints in Fedora from the installer people that they re=
ly
> >> on the /dev/md/ name being created when they create a new device. It is
> >> also inconsistent because /dev/md/<X> will be created if you run
> >> 'mdadm -As' later on.
> >
> > If they rely on the /dev/md/ name being created, then surely they shoul=
d ask
> > for it to be created.
> > Is it really harder to run "mdadm -C /dev/md/0" than "mdadm -C /dev/md0=
" ??
> >
> > If you create an array as "/dev/md0", then after subsequent "mdadm
> > -As" /dev/md0 will exist.
> > If you create an array as "/dev/md/0", then after subsequent mdadm
> > -As", /dev/md/0 will exist.
> >
> > The fact that something unasked for also exists is a bonus.
> >
> >>=20
> >> I don't see it as a major issue, but I can see why it is frustrating f=
or
> >> some and I think there is something to be said for being consistent in
> >> behavior.
> >
> > I think the behaviour is perfectly consistent.  It just follows rules t=
hat
> > are slightly less trivial that some people appear to want.
> >
> > However....
> > If you changed
> >
> > 			mp =3D map_by_uuid(&map, info->uuid);
> > 			if (mp && mp->path &&
> > 			    strncmp(mp->path, "/dev/md/", 8) =3D=3D 0) {
> > 				printf("MD_DEVNAME=3D");
> > 				print_escape(mp->path+8);
> > 				putchar('\n');
> > 			}
> >
> >
> > in Detail.c so that when mp->path were "/dev/md0", MD_DEVNAME became "0=
",
> > then you should get the result that you are after, and I probably would=
n't
> > object to the patch.
>=20
> Neil,
>=20
> Finally had time to go back and look at this - I don't quite understand
> your request here.
>=20
> As far as I can see, the above code isn't run at all during device
> creation, so I don't get how modifying it as you suggest will make
> /dev/md/111 appear if I create /dev/md111?
>=20
> Cheers,
> Jes

Wheels within wheels of deception and indirection....

mdadm doesn't create the devices directly, udev does that.

IMPORT{program}=3D"BINDIR/mdadm --detail --export $devnode"
ENV{DEVTYPE}=3D=3D"disk", ENV{MD_DEVNAME}=3D=3D"?*", SYMLINK+=3D"md/$env{MD=
_DEVNAME}"


So the symlink from /dev/md gets created iff "mdadm --detail --export"
reports an MD_DEVNAME.

Hence the change suggested.

mdadm *can* create the devices itself, but only if udev isn't running, or
mdamd has been explicitly told to ignore udev.  Normally that doesn't happe=
n.

NeilBrown


--Sig_/bsCizfrqr7ek/3.CWJfZNIN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPTZfznsnt1WYoG5AQI4exAAt5/F0CYVxCgTExBKk+9i2vHHvjXcyBIx
F2RavtL3qQCMo2v+yjxBi9bPDRQX5aaU4AxTv9FgVxggrz4+/jpCXalhUQ5T7Inf
Ak8Qf8sCNPDzXKA90zIQFuUpWT6Td2bMgzjPQmeHk/U/KV8HBMpaUmxQmAl0bXtY
+ie8hL6V3kulTWVhw+4QVDBOM0jABA3YTDnjm5n95xOpXhbKSW/FGudFd4FTIvRW
6HSsQIGtTltrvIwMRcZbKtnXztrU8NhMLnXdB+8bi1I8VagvOUFRyjpb1DspIs2n
MBMBcMZcdImyyBOsbPwzN7x2KAhXBxEVeUdn1QojYTRD9mUosGQbvMiYHXwxLhPT
ByZMAgHIRHH0/YpVzeWU0XUeYBzHB6e3UcE4J0WFn3dNIqgBm8HFWG6x6ybwXgE4
zEIwtnavsBFKLh5s2av1XmVVyzN2yW/tZxrykxf95ZwgUDH9vdX0JUJQ9+hCtqFz
A6eJYdeib0jQbPFOgZjXShDwnDegYJ4Grh2l0EaqdORG3RqzEfwQNR58BlrN1wS9
p7vJkzVeeZHs4MWeSy5DrqY0QNWadBo1De5nrEHiz7YkdH1FynZZ35JKKDlTaore
V9kF4WXmRbDpqBK3NCP8fE7CzWAuWuz23p/65yDQkP5ha3rVI4StfzCVboyCbNLA
m6xlXRe0M/0=
=LJlA
-----END PGP SIGNATURE-----

--Sig_/bsCizfrqr7ek/3.CWJfZNIN--
