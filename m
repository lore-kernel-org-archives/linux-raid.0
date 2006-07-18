From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Re: Problem with --manage
Date: Tue, 18 Jul 2006 08:08:29 +0200
Message-ID: <20060718060827.GA8314@scavenger.homeip.net>
References: <20060717112618.GA25114@scavenger.homeip.net> <17596.30157.166359.578894@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17596.30157.166359.578894@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.07.2006 15:46:53, Neil Brown wrote:
> On Monday July 17, blindcoder@scavenger.homeip.net wrote:
> >=20
> > /dev/md/0 on /boot type ext2 (rw,nogrpid)
> > /dev/md/1 on / type reiserfs (rw)
> > /dev/md/2 on /var type reiserfs (rw)
> > /dev/md/3 on /opt type reiserfs (rw)
> > /dev/md/4 on /usr type reiserfs (rw)
> > /dev/md/5 on /data type reiserfs (rw)
> >=20
> > I'm running the following kernel:
> > Linux ceres 2.6.16.18-rock #1 SMP PREEMPT Sun Jun 25 10:47:51 CEST 2006=
 i686 GNU/Linux
> >=20
> > and mdadm 2.4.
> > Now, hdb seems to be broken, even though smart says everything's fine.
> > After a day or two, hdb would fail:
> >=20
> > Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb3, disabling de=
vice. Operation continuing on 2 devices
> > Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb5, disabling de=
vice. Operation continuing on 2 devices
> > Jul 16 16:59:06 ceres kernel: raid5: Disk failure on hdb7, disabling de=
vice. Operation continuing on 2 devices
> > Jul 16 16:59:37 ceres kernel: raid5: Disk failure on hdb8, disabling de=
vice. Operation continuing on 2 devices
> > Jul 16 17:02:22 ceres kernel: raid5: Disk failure on hdb6, disabling de=
vice. Operation continuing on 2 devices
>=20
> Very odd... no other message from the kernel?  You would expect
> something if there was a real error.

This was the only output on the console. But I just checked /var/log/messag=
es
now... ouch...

---
Jul 16 16:59:36 ceres kernel: hdb: status error: status=3D0x00 { }
Jul 16 16:59:36 ceres kernel: ide: failed opcode was: 0xea
Jul 16 16:59:36 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:36 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:36 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:36 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:36 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:36 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:36 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:36 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:36 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:36 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:36 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:36 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: ide0: reset: success
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x00 { }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: ide0: reset: success
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x00 { }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
Jul 16 16:59:37 ceres kernel: end_request: I/O error, dev hdb, sector 48839=
1932
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: hdb: status error: status=3D0x10 { SeekComple=
te }
Jul 16 16:59:37 ceres kernel: ide: failed opcode was: 0xea
Jul 16 16:59:37 ceres kernel: raid5: Disk failure on hdb8, disabling device=
=2E Operation continuing on 2 devices
Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
Jul 16 16:59:37 ceres kernel: RAID5 conf printout:
Jul 16 16:59:37 ceres kernel:  --- rd:3 wd:2 fd:1
Jul 16 16:59:37 ceres kernel:  disk 0, o:0, dev:hdb8
Jul 16 16:59:37 ceres kernel:  disk 1, o:1, dev:hda8
Jul 16 16:59:37 ceres kernel:  disk 2, o:1, dev:hdc8
Jul 16 16:59:37 ceres kernel: RAID5 conf printout:
Jul 16 16:59:37 ceres kernel:  --- rd:3 wd:2 fd:1
Jul 16 16:59:37 ceres kernel:  disk 1, o:1, dev:hda8
Jul 16 16:59:37 ceres kernel:  disk 2, o:1, dev:hdc8
---

Now, is this a broken IDE controller or harddisk? Because smartctl claims
that everything is fine.

> > The problem now is, the machine hangs after the last message and I can =
only
> > turn it off by physically removing the power plug.
>=20
> alt-sysrq-P  or alt-sysrq-T give anything useful?

I tried alt-sysrq-o and -b, to no avail. Support for it is in my kernel and
it works (tested earlier).

> > When I now reboot the machine, `mdadm -A /dev/md[1-5]' will not start t=
he
> > arrays cleanly. They will all be lacking the hdb device and be 'inactiv=
e'.
> > `mdadm -R' will not start them in this state. According to
> > `mdadm --manage --help' using `mdadm --manage /dev/md/3 -a /dev/hdb6'
> > should add /dev/hdb6 to /dev/md/3, but nothing really happens.
> > After some trying, I realised that `mdadm /dev/md/3 -a /dev/hdb6' actua=
lly
> > works. So where's the problem? The help message? The parameter parsing =
code?
> > My understanding?
>=20
> I don't understand.  'mdadm --manage /dev/md/3 -a /dev/hdb6' is
> exactly the same command as without the --manage.  Maybe if you
> provide a log of exactly what you did, exactly what the messages were,
> and exactly what the result (e.g. in /proc/mdstat) was.

I don't have a script log or something, but here's what I did from an initrd
with init=3D/bin/bash

# < mount /dev /proc /sys /tmp >
# < start udevd udevtrigger udevsettle >
while read a dev c ; do
	[ "$a" !=3D "ARRAY" ] && continue
	[ -e /dev/md/${dev##*/} ] || /bin/mknod $dev b 9 ${dev##*/}
	/sbin/mdadm -A ${dev}
done < /etc/mdadm.conf

This is the mdadm.conf:
DEVICE partitions
ARRAY /dev/md/0 level=3Draid1 num-devices=3D3 UUID=3D3559ffcf:14eb9889:3826=
d6c2:c13731d7
ARRAY /dev/md/1 level=3Draid5 num-devices=3D3 UUID=3D649fc7cc:d4b52c31:240f=
ce2c:c64686e7
ARRAY /dev/md/2 level=3Draid5 num-devices=3D3 UUID=3D9a3bf634:58f39e44:27ba=
8087:d5189766
   spares=3D1
ARRAY /dev/md/3 level=3Draid5 num-devices=3D3 UUID=3D29ff75f4:66f2639c:976c=
bcfe:1bd9a1b4
   spares=3D1
ARRAY /dev/md/4 level=3Draid5 num-devices=3D3 UUID=3Dd4799be3:5b157884:e387=
18c2:c05ab840
   spares=3D1
ARRAY /dev/md/5 level=3Draid5 num-devices=3D3 UUID=3Dca4a6110:4533d8d5:0e2e=
d4e1:2f5805b2
   spares=3D1

MAIL root@localhost

At this moment, only /dev/md/0 was active. Reconstructed, /proc/mdstat look=
ed
something like this:

Personalities : [linear] [raid0] [raid1] [raid5] [raid4]
md5 : inactive raid5 hda8[1] hdc8[2]
      451426304 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

md4 : inactive raid5 hda7[1] hdc7[2]
      13992320 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

md3 : inactive raid5 hdc6[1] hda6[0]
      8000128 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

md2 : inactive raid5 hda5[1] hdc5[2]
      5991936 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

md1 : inactive raid5 hda3[1] hdc3[2]
      5992064 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

md0 : active raid1 hdb1[0] hdc1[2] hda1[1]
      497856 blocks [3/3] [UUU]

unused devices: <none>

I'm not sure about the line containing blocks, level and such, but I'm sure
about the first line of each mdx.

At this point, doing anything to /dev/md/[1-5] would give me an Input/Output
error.

Running
# mdadm -R /dev/md/1
would give me this error:
Jul 16 17:17:42 ceres kernel: raid5: cannot start dirty degraded array for =
md1

# mdadm --manage /dev/md/1 --add /dev/hdb3
would do nothing. No message on stdout, stderr, kernel or anything. It would
just do nothing.
# mdadm /dev/md/1 --add /dev/hdb3
would in turn add hdb3 to md/1 and then I was able to
# mdadm -R /dev/md/1
and the resync would start.

Right now I'm quite sure the problem will arise again (see messages above).
I'll try to create a script log of what happens when I encounter the problem
again.


Greetings,
	Benjamin
--=20
Today, memory either forgets things when you don't want it to,
or remembers things long after they're better forgotten.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEvHrbr0OTeImXvg8RArIjAJ98BKm6La+u5fMHlj4tto7HHmeQ+gCaAxuf
mviDTagD8G/mcW7ovqghmEQ=
=KMFx
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
