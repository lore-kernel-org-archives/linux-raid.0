From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Tue, 18 Apr 2017 09:31:15 +1000
Message-ID: <87pogatxvg.fsf@notabene.neil.brown.name>
References: <87a87lutj7.fsf@notabene.neil.brown.name> <20170413054723.2spvhtze6bljkaop@kernel.org> <877f2muvmc.fsf@notabene.neil.brown.name> <006d05e1-2517-ca5c-00b4-c699a5bd793d@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006d05e1-2517-ca5c-00b4-c699a5bd793d@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 15 2017, Anthony Youngman wrote:

> On 15/04/17 05:45, NeilBrown wrote:
>> So at present, callers of blkdev_get_by_dev() need to do their own
>> bdev_read_only() tests before writing.
>> We could discuss where in md.c is the best place to put them, but unless
>> you want to take on a largish project to 'fix' (or audit) all callers of
>> blkdev_get_by_dev(), they need to go in md somewhere.
>
> anthony@crappit:~/gitstuff/linux-stable> git grep -a blkdev_get_by_dev >=
=20
> blkdev_get_by_dev.txt
> anthony@crappit:~/gitstuff/linux-stable> cat blkdev_get_by_dev.txt
> drivers/block/xen-blkback/xenbus.c:     bdev =3D=20
> blkdev_get_by_dev(vbd->pdevice, vbd->readonly ?
> drivers/md/dm.c:        bdev =3D blkdev_get_by_dev(dev, td->dm_dev.mode |=
=20
> FMODE_EXCL, _claim_ptr);
> drivers/md/md.c:        bdev =3D blkdev_get_by_dev(dev,=20
> FMODE_READ|FMODE_WRITE|FMODE_EXCL,
> drivers/mtd/devices/block2mtd.c:                bdev =3D=20
> blkdev_get_by_dev(devt, mode, dev);
> fs/block_dev.c: * blkdev_get_by_dev - open a block device by device number
> fs/block_dev.c:struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t=
=20
> mode, void *holder)
> fs/block_dev.c:EXPORT_SYMBOL(blkdev_get_by_dev);
> fs/ext4/super.c:        bdev =3D blkdev_get_by_dev(dev,=20
> FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
> fs/f2fs/super.c:=20
> blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev,
> fs/jfs/jfs_logmgr.c:    bdev =3D blkdev_get_by_dev(sbi->logdev,=20
> FMODE_READ|FMODE_WRITE|FMODE_EXCL,
> fs/nfs/blocklayout/dev.c:       bdev =3D blkdev_get_by_dev(dev, FMODE_REA=
D=20
> | FMODE_WRITE, NULL);
> fs/reiserfs/journal.c:          journal->j_dev_bd =3D=20
> blkdev_get_by_dev(jdev, blkdev_mode,
> include/linux/fs.h:extern struct block_device *blkdev_get_by_dev(dev_t=20
> dev, fmode_t mode,
> kernel/power/swap.c:    hib_resume_bdev =3D=20
> blkdev_get_by_dev(swsusp_resume_device,
> anthony@crappit:~/gitstuff/linux-stable>
>
> So, if I'm mad enough to take this on, does that mean going through all=20
> of these checking/fixing them to test for a return code of -EACCESS?

Yes, where "fixing" means understanding how the bdev is used in
each case, and what mode is really required and making it behave
correctly in all circumstances.
Maybe that means just propagating the error upwards.
Maybe it means retrying with only FMODE_READ, and recording that no
write access was available.  At the very least, this fact would be used
to pass the right fmode_t to blkdev_put.
Maybe it means always using FMODE_READ because FMODE_WRITE isn't
actually needed (though that seems unlikely).

Maybe it also means bd_write_holder could be changed to a counter
instead of a flag, if we can convince ourselves that the use of @mode
in blkdev_get/put() is no longer "too fragile".

NeilBrown

>
> No promises that I will, I keep on wanting to do this sort of stuff and=20
> then life gets in the way, but if I can't do it it'll go on the list of=20
> projects on the raid wiki.
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj1UEMACgkQOeye3VZi
gbk+YQ//QdccaZalw4LH1WWYqEJPgIis9d43KxOYRW7RW+6AYoAQT8s3muoz+Ge+
BDJjUH9C6jwY54ydGOqxk+Lw+vFKr9W5OtMxilKGDsHSRer0T94Lh1n3bI/4UZK1
HODvyXNOVMEQvo5m4+b0aPOts3waY7d8TX5OF4YtTufO9Q0EKsAd9xrHACtkyx61
ekrzZs3uw8gRfAaH+OqKRsBsddhMk/ayuWbjYPX9ivnv+UOLKRDlXf+Gx9icm+2O
SWVD9KVq26WLIvQ+9kEZCaSyhhSqt+AdAlYTk3Q4viMi5qqn1H89K4NSA8soLglc
xoRpmCcv/xjyWxNKLxMmhl6WMp/BLX6JQTXK13VQTdna/MuX+X1OzqG3XGUQQWEi
RyM07IMCletuGHDHuoChezFPhzJKZ4I59OIyX+fm188fydn20YjhoyHQwDPIpPzU
/25ZdLMLq2r+y1XUfdZyqMm/KgohtikJJkPitj24gsfDn8oH1OzsLgGdGvO93Y1d
DfDID96CS+r7l5Re8YGTpVKZLN9JqFxQpficQypiKQSwA8uhnD/ovOM9oOMWUEGl
A2A5Nty9GKy0cYD5f2u14BPweSHc/FpjEZr3SrOw+NTdepuCnZVM4pUqoXBTvZlX
CTBtnbByWAz2AkfxaZ8lfBsteduOo/TT8to+VxMT7r6t32jIoO4=
=q+GC
-----END PGP SIGNATURE-----
--=-=-=--
