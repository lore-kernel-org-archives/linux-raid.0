From: NeilBrown <neilb@suse.de>
Subject: Re: md disk fault communication code
Date: Fri, 18 Apr 2014 16:13:34 +1000
Message-ID: <20140418161334.025262bb@notabene.brown>
References: <CAAcCrhQEW4Yzz2YQri3hzNExQVWqquvN8dzzxZN+5DBZbAtcRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6bR5EC05JagHgVMNGkILd97"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAcCrhQEW4Yzz2YQri3hzNExQVWqquvN8dzzxZN+5DBZbAtcRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sonu a <p10sonu@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6bR5EC05JagHgVMNGkILd97
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Apr 2014 13:38:58 +0800 Sonu a <p10sonu@gmail.com> wrote:

> when disk is removed with out mdadm as I see from the stack below the
> communication reaching the md driver.
>=20
> dump_stack+0x49/0x5e
> md_error+0x50/0x110 [md_mod]
> state_store+0x43/0x300 [md_mod]
> rdev_attr_store+0xad/0xd0 [md_mod]
> ? sysfs_write_file+0x62/0x1c0
> sysfs_write_file+0x138/0x1c0
> vfs_write+0xc0/0x1e0
> SyS_write+0x5a/0xa0
> ? __audit_syscall_exit+0x246/0x2f0
> system_call_fastpath+0x16/0x1b
>=20
> could someone point me to the code which is monitoring scsi disks
> status and thus calling md driver sysfs interface accordingly ?

I think you ask asking how md_error gets called when a SCSI device fails,
having already discovered how it is called when you explicitly write to a
sysfs file.

Nothing monitors the scsi disks.  md only discovers failure if it sends a
request to a disk, and the request signals an error.  If you search for
'bi_end_io', functions assigned to this field are called when a request
finishes.  Those functions might call md_error if the request failed, or th=
ey
might schedule some other handling first to try to correct the error.

NeilBrown

--Sig_/6bR5EC05JagHgVMNGkILd97
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1DClTnsnt1WYoG5AQIlEA/8Dt/a695EwyKSFXgpieXIgDfmzKHBbR2Q
D9FsNv8pn9s1rJgfkJu+9VGHNqu6v2JpBEi2V1uWMop8pr4lHk+4ab5orDfdUG1t
eKhm+CtkBbfQO1g1jvcdDSlN/tsys5JpURISzi35A8BkN72ZY6/6HXpieUEAsiXe
0cSxvjvyB8HIEpqA9y9p6ImZc28C5lHsEO/C8+yV8YN2VIVK6MBUo08PXPkET9Ue
t2KBS6GQRbcSbBiF4LRfkruqEq3sUtV5H3kfTSWadEJLt9v4cMH5JTMCa37lX0zJ
AD2mGgj7j+D7GJ5TAC4xCJajmxiATy26eNZ7dk1igqQwWvlZUvo/Yy40Br4kXYAZ
JMu3ypGkpHOD/eThrVB0zheUf28yLSeu7q70HGRtvSz80Uy4bx5gsKRrdkdEfJbk
9k9Rh74JcWon36HBO4iGzVrcY5VUVTl/v0mkriMtTVD7HxryFYEQN0BAOVvmj6Df
R0mwDzRGyioqoyvCuHwTJcwcXjWAuw+cQnw4UV9bzjI9smv67g8N429B4FLOSu1+
nx4ZiL8qDVJYHKj8gWGwoA7JYp0Eg1PfI5Y/QDJPxcl04V4XnRfI6d2n5tSks57r
ezU3gcAyJQg4SGCPGnH+4X/BTaF/YGTnqfP8beUl0jWz/miWPxYEhlkk91VxD5yg
J6HhviTduK8=
=G2xR
-----END PGP SIGNATURE-----

--Sig_/6bR5EC05JagHgVMNGkILd97--
