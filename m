From: NeilBrown <neilb@suse.com>
Subject: Re: Level change from 4 disk RAID5 to 4 disk RAID6
Date: Mon, 10 Apr 2017 11:04:30 +1000
Message-ID: <87vaqdxech.fsf@notabene.neil.brown.name>
References: <20170408214239.GF10267@lars-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170408214239.GF10267@lars-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: LM <linux-raid@moellendorf.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Apr 08 2017, LM wrote:

> Hi,
>
> I have a 4 disk RAID5, the used dev size is 640.05 GB. Now I want to
> replace the 4 disks by 4 disks with a size of 2TB each.
>
> As far as I understand the man page, this can be achieved by replacing
> the devices one after another and for each device rebuild the degraded
> array with:
>
>    mdadm /dev/md0 --add /dev/sdX1
>
> Then the level change can be done together with growing the array:
>
>    mdadm --grow /dev/md0 --level=raid6 --backup-file=/root/backup-md0
>
> Does this work?
>
> I am asking if it works, because the man page also says:
>
>> mdadm --grow /dev/md4 --level=6 --backup-file=/root/backup-md4
>>        The array /dev/md4 which is currently a RAID5 array will
>>        be converted to RAID6.  There should normally already be
>>        a spare drive attached to the array as a RAID6 needs one
>>        more drive than a matching RAID5.
>
> And in my case only the size of disks is increased, not their number.
>

Yes, it probably works, and you probably don't need a backup file.
Though you might need to explicitly tell mdadm to keep the number of
devices unchanged by specifying "--raid-disk=4".

You probably aren't very encouraged that I say "probably" and "might",
and this is deliberate.

I recommend that you crate 4 10Meg files, use losetup to create 10M
devices, and build a RAID5 over them with --size=5M.
Then try the --grow --level=6 command, and see what happens.
If you mess up, you can easily start from scratch and try again.
If it works, you can have some confidence that the same process will
have the same result on real devices.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq2h4ACgkQOeye3VZi
gbnxdRAAlxNkafimVNNDl+NnfLBSF/muiO8WrKjmQQoF2MpE+wR+EofEJcDwndTW
UfXdERffXd/k/MMl80Hhuo9eUpb7ZDE+lesnLqkZCHUW49w3h+KDB6DCE2oR9FB8
l0I5ILk1v3ZLD6ojgs2/c3O2QCFnu+GVsaH6es+1DRHDAv+oG0xKuADogpmYOwSk
CcXejK0wv9BSdEHBkGFPtbDY7Wa/ujwXvQl2lgxn2h2kDmngeRoBLF0HBoM0R7mY
dOcZDp0of0S1hdtabjmj5C9Q0WQQX37HpJjkr+BWTw1RAjrxRjD2mHsWiHbaJd3e
bv10aH7U1i90tqz/ZceluIkPuqfL25k4CUIF0Bap5kx5Vid9LDSiXtfzwLew6lHC
vPSskX2KSASgqD8LrTqqxPnS+VmPt47s+cz2cVMPkmM7HLbApzBZDBDHY5/9FIg1
obR+Vr5zwPLeMwxVPXrE5tkgSH3EWSeWvimX4Sl2XQHMNAM0VXElHnQXfDsaz3vM
pxS8F32DyjklXraqIGPVW+KKJT6ZfFNmbCMitXnSe7bjAjlTTfAaUU7iXAFlQszY
C98c8y1qjlMRCtuwaVT9N8kaE2l7POCYmJuzTWwqJVdEdCmsQr48gycGI5AZ6Ngz
uuUellpeEhIRltbhCTwogHvJKctiKjTN+c2kmNRcowTYHOx1B9M=
=a3Tf
-----END PGP SIGNATURE-----
--=-=-=--
