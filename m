From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 partition set to spare
Date: Sun, 15 Jan 2012 16:18:31 +1100
Message-ID: <20120115161831.6e46f413@notabene.brown>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
	<4EFD9956.5050703@redhat.com>
	<CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
	<4EFEDF2A.5060408@redhat.com>
	<CA+q4O7NhcEhYLre45+u6V8nnmCg1EYi=3Lbn4_5AS6Ei5J1mTQ@mail.gmail.com>
	<CA+q4O7NjK6Aj3Djs2g+qPu69=knOKvu9=wFy-YLdmw4Fi3k2Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lHEFi94f/tptThzoXVa77k8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+q4O7NjK6Aj3Djs2g+qPu69=knOKvu9=wFy-YLdmw4Fi3k2Gw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Carlson <stevengcarlson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lHEFi94f/tptThzoXVa77k8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Jan 2012 15:42:58 -0600 Steve Carlson <stevengcarlson@gmail.com>
wrote:

> On Sat, Dec 31, 2011 at 5:37 PM, Steve Carlson <stevengcarlson@gmail.com>=
 wrote:
> >> On Sat, Dec 31, 2011 at 4:08 AM, Jes Sorensen wrote:
> >> Hi Steve,
> >>
> >> What I meant here is that I would like to see the dmesg output at this
> >> point, to see if there were any read errors reported during the assemb=
ly.
> >>
> >>> I also ran extended self tests just to be thorough, and they both came
> >>> back error free. =C2=A0I'm unsure as to whether that puts them in the=
 clear
> >>> for bad sectors though.
> >>
> >> There were read errors in the dmesg output you posted earlier, which is
> >> why I am wary of it.
> >>
> >> Cheers,
> >> Jes
> >
> > Jes,
> >
> > This is /var/log/messages from boot to stopping and reassembling md2.
> > I think this is what you wanted, I'm not sure what more I can give
> > you.
> > http://dl.dropbox.com/u/2776371/raid/mdadm_stop_dmesg_c_mdadm_assemble_=
var_log_message.txt
> >
> > -Steve
>=20
>=20
>=20
> Hi all,
>=20
> This is still unresolved.  What else could I try short of breaking and
> rebuilding the array?

I don't know how the array could have got in this state.  IO errors on a
RAID0 don't mark the devices as faulty.
You would have to explicitly
   mdadm /dev/md2 --fail /dev/sdb3
or something like that - and I doubt you did that.

Anyway:
 mdadm -S /dev/md2
 mdadm -C /dev/md2 -e 0.90 -c 64 -l 0 -n 2 /dev/sda3 /dev/sdb3

should get you going again.  All the data should be there except for anythi=
ng
that the hard drive has decided to keep for itself.

NeilBrown

--Sig_/lHEFi94f/tptThzoXVa77k8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxJhpznsnt1WYoG5AQK0OBAAvqNppMp4Wtg2cDTmhAOWWm9xWBn6Uyvr
FQ8N1InEiPLfc19QmqHllFEZ0hkLkC9KitCoG55k4rrzlWY9wFJMQLnbsY3p5hOY
+PA3Kic5EMOqSOQDaISpquj3PhDgrMiRWCJwgVkRd9yoWyEY9VgAE2aC2/4Vr4t8
wvv9c40oYdaEgdmlGucRfGZMpP+oWa4kK8UFQGXvMC7tYIyMMa+jrk2wawMMzl1N
StjjddlhDhH5kuJbwpacGl1gzZiUPIo+segsquGXQ7+D3rXXZOZh0VuwJjcNDac3
uwgUU913JN6TuMIZR861pJ48pJRveJp57dMEFHC2tbYj9YYe53seKcNEQOusvItH
4JHk6XyqZm9Y34kEq6SDEoBA1LTjAo2bxLFi5WdQ7sbqWymV6YprqSKVxG4Kf5IG
fS96faRxasl4hLrmTHjqB6BhMrlQzmA94foxO8om0kXjLVLhahBPtH6fOF0fSDm7
zOicYrDoFuZsL3OJ7vE9WIChhDKPNrn4jVVkEUHGYv2/PzDOyVyQQViS7jIDkNbV
5T7xh8rRThd3ZPCB2m8XHeMrX0oqcnC93hjBTOhsgWCP5DwEy5xegNU24Gb+l9Zd
C0xaFkPXKZ7q7laSvUkIQSGzZYNuCFwpUBvEH/Trx2rhlowfj5J0lD9SIwjLGxlJ
fLeUNz8NGAw=
=FrYK
-----END PGP SIGNATURE-----

--Sig_/lHEFi94f/tptThzoXVa77k8--
