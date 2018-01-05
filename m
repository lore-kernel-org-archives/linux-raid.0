From: NeilBrown <neilb@suse.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Fri, 05 Jan 2018 12:05:28 +1100
Message-ID: <871sj5dsiv.fsf@notabene.neil.brown.name>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com> <87373og9z9.fsf@notabene.neil.brown.name> <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com> <87r2r8dk80.fsf@notabene.neil.brown.name> <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: RQM <rqm@protonmail.com>
Cc: "linux-raid\\\\\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Jan 04 2018, RQM wrote:

> Hello,
>
>> I needed "mdadm -E" the components of the array, so the partitions
>> rather than the whole devices. e.g. /dev/sdb1, not /dev/sdb.
>
> Sorry, that should have occurred to me. Here's the output:
> https://paste.ubuntu.com/26319689/
>
> Indeed, bad blocks are present on two devices.
>
>> You can remove the bad block by over-writing it.
>> dd if=/dev/zero of=/dev/md0 bs=4K seek=1598030208 count=1
>> though that might corrupt some file containing the block.
>
> I have tried that just now, but before running mdadm -E above. dd appears to succeed when writing to the bad block, but after that, reading that block with dd fails again:
> "dd: error reading '/dev/md0': Input/output error"
>
> In dmesg, the following errors appear:
> [220444.068715] VFS: Dirty inode writeback failed for block device md0 (err=-5).
> [220445.850229] Buffer I/O error on dev md0, logical block 1598030208, async page read
>
> I have repeated the dd write-then-read experiment, with identical results.
>
> The filesystem is indeed ext4, but it's not of tremendous importance to me that all data is recovered, as the array contains backup data only. However, I would like to get the backup system back into operation, so I'd be very grateful for further hints how to get the array into a usable state.

The easiest approach is to remove the bad block log.
Stop array, and then assemble with --update=no-bbl.
e.g
  mdadm -S /dev/md0
  mdadm -A /dev/md0 --update=no-bbl /dev/sd[bcdef]3

Before you do that though, please take a dump of the metadata and send
it to me, in case I get motivated to figure out why writing didn't work.

 mkdir /tmp/dump
 mdadm --dump /tmp/dump /dev/sd[bcdef]3
 tar czSf /tmp/dump.tgz /tmp/dump

The files in /tmp are sparse images of the hard drives with only
the metadata present.  The 'S' flag to tar should cause it to notice
this and create a tiny tgz file.
Then send me /tmp/dump.tgz.

Thanks,
NeilBrown


>
> Thank you so much for your help so far!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpOz1gACgkQOeye3VZi
gbkBEg/9Gi9KWMdz9806YqG2iwb9kRxaa7RJWj7CvfLbnkp3l3PTFREljuUII+6v
RvL0it7JLiQenKqSl5BfX+F2tZc9Feterl1T3uzRUaG7hzj7g5ktyhesOICZOY5J
MdXYNHOugKzkBTGRc33rap0zBD07DQuhC7hVY8+JsUjLL8xBM/A/ZUk2vp8iJJxY
5Y2mUzhnlhvxfMmY1cU9CA/6PhXcrrLgz66JuWS2g8+bEO2c8UmV1ZCciSqxp60Q
9xD6zFQWSHAg/Jr3ahp2Os/20vSxg5HvmBNDLaHA9QghR6OUn99tyBvv1FDfQ8zC
vh5BPfmoKkzy3EGzY5+c5Uabqg/lcHNumNn4xIA4MNsrYOaNQHWncRFTsXv03uG1
N5jm6g2xh5REzpIHfMomhWQXOo+JNaaPuTQhS32hZKZbv3Ulz3cZ6kKUbtSN0nEn
k1ZlNkHZ8U/h0ltPdA+zJDzt/kZmI1N4HAVZEp0d8mtxc8b6WdW6I2RR6W7Cw2eG
kdB243aaw6WHgJrMjVFRuXyuBxAVDS5aM1cjfkbMkHuroPKffnRFo6fK9CZ5UuB4
cwGN4QlMG1jk+lxEaY/OD1M8fFTlMrJmBUUbuU6NFuCdrkCdBAPbuGNxOQSXzVzr
kAlTR2vJ5w/FO14KOKkRadaTYjnUlydSXVnQ1Tg9gRxdxURdlig=
=vWi+
-----END PGP SIGNATURE-----
--=-=-=--
