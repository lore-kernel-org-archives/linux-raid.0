From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Thu, 5 Sep 2013 12:11:23 +1000
Message-ID: <20130905121123.27968f9f@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4/Ho5nfyl5JTbw/yLL44Bci"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4/Ho5nfyl5JTbw/yLL44Bci
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Sep 2013 09:36:27 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hi Neil,
>=20
> On Wed, Sep 4, 2013 at 8:08 AM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 3 Sep 2013 17:54:55 +0200 Francis Moreau <francis.moro@gmail.co=
m>
> > wrote:
> >
> >> Hello Martin :)
> >>
> >> I gave 3.3 release a try and I have a first issue: basically starting
> >> mdmon (3.3) with --takeover twice make mdmon failing on the second
> >> run.
> >>
> >> Please find details below:
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> md126 : active raid1 sdb[1] sda[0]
> >>       2064384 blocks super external:/md127/0 [2/2] [UU]
> >>
> >> md127 : inactive sdb[1](S) sda[0](S)
> >>       65536 blocks super external:ddf
> >>
> >> # ps aux | grep dmon
> >> root       311  0.4  1.0  80580 10944 ?        SLsl 17:46   0:00
> >> @sbin/mdmon --takeover md127
> >>
> >> # ./mdmon --takeover --all
> >>
> >> # ps aux | grep dmon
> >> root      3182  1.3  1.0  15156 11056 ?        SLsl 17:50   0:00
> >> ./mdmon --takeover md127
> >>
> >> # ./mdmon --takeover --all
> >> ...
> >> monitor: wake ( )
> >> monitor: wake ( )
> >> monitor: wake ( )
> >> monitor: wake ( )
> >> monitor: wake ( )
> >> monitor: wake ( 12:array_state )
> >> read_and_act(0): 1378223477.512347 state:clean prev:clean action:idle
> >> prev: idle start:18446744073709551615
> >> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 184467440737=
09551615
> >> manage_new: inst: 0 action: 11 state: 12
> >> mdmon: ddf_open_new: subarray 0 doesn't exist
> >> mdmon: failed to monitor external:/md127/0
> >> free_aa: sys_name: md126
> >> read_and_act(0): state:clean action:idle next( )
> >> manage_new: inst: 0 action: 20 state: 21
> >> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b=
1n
> >> free_aa: sys_name: md126
> >> caught sigterm, all clean... exiting
> >> monitor: wake ( )
> >> no arrays to monitor... exiting
> >>
> >> # ps aux | grep dmon
> >> #
> >>
> >> Thanks
> >
> > I can't easily reproduce this.
>=20
> This is weird, it's 100% reproductible here.
>=20
> >
> > Can you run "mdmon --takeover" in one window, then the next "mdmon
> > --takeover" is a different window so we can clearly see which messages =
are
> > coming from the mdmon which is exiting and which are coming from the md=
mon
> > which is starting.
>=20
>=20
> Sure.
>=20
> A note that I should have probably tell previously: before I'm
> starting manually the first mdmon process, an old mdmon process is
> running which was started by the system at boot and this mdmon is
> 3.2.6.
>=20
> ###
> ### window 1: starting manually the first mdmon --takeover process ####
> ###
>=20
> # ps aux | grep dmon
> root       312  0.5  1.0  80580 10944 ?        SLsl 09:24   0:00
> @sbin/mdmon --takeover md127
>=20
> ## Note: this mdmon process was started at system boot and is 3.2.6
>=20
> # ./mdmon --takeover --all
> ...
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> manage_new: inst: 0 action: 11 state: 12
> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
> monitor: caught signal
> read_and_act(0): 1378279619.393600 state:clean prev:inactive
> action:idle prev: idle start:18446744073709551615
> pr_state/ddf_set_array_state: 0(s=3D10 i=3D02)
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) dirty 184467440737095=
51615
> pr_state/ddf_set_array_state: 0(s=3D00 i=3D02)
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 184467440737095=
51615
> pr_state/__write_init_super_ddf: 0(s=3D00 i=3D02)
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> ddf: sync_metadata
> read_and_act(0): state:clean action:idle next( )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279621.980656 state:write-pending prev:clean
> action:idle prev: idle start:18446744073709551615
> pr_state/ddf_set_array_state: 0(s=3D10 i=3D02)
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (7) dirty 184467440737095=
51615
> pr_state/__write_init_super_ddf: 0(s=3D10 i=3D02)
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> ddf: sync_metadata
> read_and_act(0): state:write-pending action:idle next( state:active )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279622.381087 state:active prev:write-pending
> action:idle prev: idle start:18446744073709551615
> read_and_act(0): state:active action:idle next( )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279626.520845 state:active-idle prev:active
> action:idle prev: idle start:18446744073709551615
> read_and_act(0): state:active-idle action:idle next( state:clean )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279626.524532 state:clean prev:active-idle
> action:idle prev: idle start:18446744073709551615
> pr_state/ddf_set_array_state: 0(s=3D00 i=3D02)
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 184467440737095=
51615
> pr_state/__write_init_super_ddf: 0(s=3D00 i=3D02)
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> ddf: sync_metadata
> read_and_act(0): state:clean action:idle next( )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279626.981157 state:write-pending prev:clean
> action:idle prev: idle start:18446744073709551615
> pr_state/ddf_set_array_state: 0(s=3D10 i=3D02)
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (7) dirty 184467440737095=
51615
> pr_state/__write_init_super_ddf: 0(s=3D10 i=3D02)
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk b342fbdc for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> writing conf record 0 on disk 2cf00056 for
> Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
> ddf: sync_metadata
> read_and_act(0): state:write-pending action:idle next( state:active )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279627.376402 state:active prev:write-pending
> action:idle prev: idle start:18446744073709551615
> read_and_act(0): state:active action:idle next( )
>=20
> [launching new mdmon --takeover....]
>=20
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378279678.858186 state:clean prev:clean action:idle
> prev: idle start:18446744073709551615
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 184467440737095=
51615
> read_and_act(0): state:clean action:idle next( )
> manage_new: inst: 0 action: 20 state: 21
> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
> free_aa: sys_name: md126
> caught sigterm, all clean... exiting
>=20
> ###
> ### window 2: starting the 2nd mdmon process ###
> ###
>=20
> #./mdmon --takeover --all
> ...
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> manage_new: inst: 0 action: 11 state: 12
> mdmon: ddf_open_new: subarray 0 doesn't exist
> mdmon: failed to monitor external:/md127/0
> free_aa: sys_name: md126
> monitor: wake ( )
> no arrays to monitor... exiting
>=20

The line

> mdmon: ddf_open_new: subarray 0 doesn't exist

is the problem.  mdmon read the metadata from the array but didn't find
subarray '0' in there even though the previous mdmon clearly did:

> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n

This suggests that even though it succeeded in reading the metadata (it wou=
ld
have printed
    Cannot load metadata for md127
and exited if it had), the metadata is somehow inconsistent.

Could you trying running each mdmon under strace:
  strace -f -o /tmp/str-1 ./mddmon --takeover --all

and attach the two /tmp/str-? files?

Also what is the difference between
  mdadm --examine /dev/sda
and
  mdadm --examine /dev/sdb
??

Thanks,
NeilBrown

--Sig_/4/Ho5nfyl5JTbw/yLL44Bci
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUifoSznsnt1WYoG5AQJjuBAAh+XwYS7JCNOJ3MOcyrs++2zm9TErHfoq
BqUUo94G0RDHlhAJqK6QOWXuh6Ho2vPHGSVSSzOAIwI+oL5llTkdhV732TUsWn14
cWxFueNlzahPaswxUNee9QdrNb0eihLIr2GhilSaYK/CXuhIto0Ydl6/ZFquRPD+
xOp7v3w93yr3kw5K1rnJLCUPzF2um1cFMfSQC1i9WCLxUJ0zfv43Kt1a5Oh+A3mg
NhT/rMb9DMEx8kNRtzePOoSTaPLQVbE5EBGGE3YxDR4GO1QXYRxzH6bCSUjFwIb3
zwXmhpb2kJb/uXIRvNMaNsRu97tmH0OBOkYbLAXwEX19xs4HR7aM6s77TiLdj2kH
9XauYjxTgfWyfDjpaw4Z2vJO4hBgqq4XKtLowvv/sAnNVFX6VaeluNgdvDRhJHAq
izfyfWg3CbhkevOeKZNtTg6Q9bOtq/xHjpPL0kZYwUNTmJ4bVtO68xNU8ZS3cjkG
k3rE9FnM8XzsvR1ymQSowhNCg3D7TilYWqB7tXW9Gayqi6qop33cCxxQZipjF+42
UJo3aRytUJEhxaH+KSwKQdW8ec6ySnc3x5hLvcIz+/ilUq732pvzUWPwTTKRSDBB
H6JloDzYUVi6zTUJBwSByVfvra+ZSHU4NgYtF5QGDuSEHwo59A77S7v8nPrLepyC
hQIaK12Gbl8=
=Bfxe
-----END PGP SIGNATURE-----

--Sig_/4/Ho5nfyl5JTbw/yLL44Bci--
