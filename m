From: NeilBrown <neilb@suse.com>
Subject: Re: [opensuse] raid device mounting problem in Leap 42.2
Date: Fri, 14 Jul 2017 15:35:35 +1000
Message-ID: <874luf1syg.fsf@notabene.neil.brown.name>
References: <a7cc2751c4c0b89dee040c1522590fb5@gmail.hu> <ok4bkp$gb0$1@saturn.local.net> <41e64fb5b9e54bf18aff2d663d0649d8@gmail.hu> <CAA91j0UND1UmwOc46G+o1Mh3dKMG9M_HiYxFdXwWO03D=EztpA@mail.gmail.com> <76df60214c0039114ba0a4b6f0f515bc@gmail.hu> <CAA91j0WXkBnSa+F7u95SWMCtR6nYnUN3uzRLj9jqPoCFX2LNXQ@mail.gmail.com> <596628E7.8020905@youngman.org.uk> <CAA91j0Uyz2xZkpo3YDrkQRhYt5FoG4b-Bwhc7HF3ko40i1xs3A@mail.gmail.com> <d71443c0d631c80af4d09c6098b85359@gmail.hu> <5967FFAD.6030807@youngman.org.uk> <87r2xj23v2.fsf@notabene.neil.brown.name> <6df95e9a-1281-ccc6-0d40-7962d8f42bc5@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6df95e9a-1281-ccc6-0d40-7962d8f42bc5@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, suse <opensuse@opensuse.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 13 2017, David C. Rankin wrote:

> On 07/13/2017 08:40 PM, NeilBrown wrote:
>
>>=20
>> To the byte?  I really like to see the output of commands that report
>> sizes, rather than have someone claim "were the same size".  It isn't
>> that I don't trust you.  I just don't trust humans in general (myself in=
cluded).
>>=20
>> NeilBrown
>>=20
>
> Yep,
>
>   Earlier in the post we have:

Thanks.  (I'm not subscribed to opensuse@opensuse.org, so I couldn't see
any of this before.  Also, people on that list might not see my reply.
Feel free to forward this email to that list.
I'm Ccing to linux-raid as that is the list that I first heard about
this on).

>
> <quote>
>
> It is assembled from /dev/sdb9 and /dev/sdc9.
>
> # sfdisk -l /dev/sdb
> Units: sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Device     Boot     Start       End   Sectors   Size Id Type
> /dev/sdb9       298005813 360916289  62910477    30G fd Linux raid autode=
tect
>
> # sfdisk -l /dev/sdc
> Units: sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Device     Boot     Start       End   Sectors   Size Id Type
> /dev/sdc9       298005813 360916289  62910477    30G fd Linux raid autode=
tect

Device is 62910477 sectors.  So 29.998053 GiB or 32.210164 GB


>
> </quote>
>
> and the following at the beginning of the thread
>
> <quote>
>
>
> I have several mdraid RAID1 (mirror) devices I used without
> problem in openSUSE 12.2. In openSUSE Leap 42.2 I can't
> mount some of the same raid devices.
>
> In openSUSE 12.2 I can mount the raid device:
>
> cat /proc/mdstat
>
> md9 : active raid1 sdc9[1] sdb9[0]
>       31455164 blocks super 1.0 [2/2] [UU]

Array is 31455164 KiB, so 29.997982 GiB or 32.210087 GB.

>
> # mount /dev/md9 /mnt -o ro
> #
>
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md9         30G   28G  364M  99% /mnt
>

"-h" means to use powers of 1024, so this "30G" compares with
the array size of "29.997982 GiB".

I don't know exactly how 'df' formats numbers (and reading the code
makes my head spin), but I wouldn't be surprised if it chose to print
29.997 as 30.

Can we see the output of "df" without the "-h" ('h' stands for 'human'
and we know I don't trust those :-).

>
>
> In openSUSE Leap 42.2 I can't mount the same raid device:
>
> cat /proc/mdstat
>
> md9 : active raid1 sdc9[1] sdb9[0]
>       31455164 blocks super 1.0 [2/2] [UU]
>
>
> # mount /dev/md9 /mnt -o ro
> mount: wrong fs type, bad option, bad superblock on /dev/md9,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.

Has there been any report of the output of this "dmesg | tail" command?

>
>
> Why is this and how can I fix it?
>
> </quote>
>
> Glad to see we have a direct pipeline to the master here :)

So I went hunting in the archives (I shouldn't have to..) and found:

> The filesystem size (according to the superblock) is 7863809 blocks
> The physical size of the device is 7863791 blocks

This would be 4K blocks, so
  filesystem: 7863809 blocks, 31455236K, 62910472 sectors
  device:     7863791 blocks, 31455164K, 62910328 sectors

So the sd[bc]9 is 5 sectors larger than the filesystem.

Hmm. opensuse 12.2... That had a 3.4.6 kernel?

3.4 (and up to 4.3) had separate ext3 and ext4 implementations.
In 4.3, ext3 was discarded and ext4 used to manage ext3 filesystems.
So small changes in behaviour for corner cases are not impossible.

ext4 has a test :
	/* check blocks count against device size */
	blocks_count =3D sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
		       "exceeds size of device (%llu blocks)",
		       ext4_blocks_count(es), blocks_count);
		goto failed_mount;
	}

which is presumably failing.  If "dmesg | tail" had been run, we
probably would have seen that.
This test has been present since 2.6.30.
I don't think ext3 ever got this test (until it became ext4).

So there is your answer.
The filesystem was created on the member device, instead of on the
array.
The kernel being used didn't check for this inconsistency.
fsck does, but presumably was never run.
The new kernel does check - as it should.

I would suggest:
1/ stop the array (mdadm -S /dev/md9)
2/ run fsck --force /dev/sdb9
3/ run resize2fs /dev/sdb9 29G  (or something like that)
4/ "mdadm -C /dev/md9 -l1 -e 1.0 -n2 /dev/sdb9 missing"
5/ "fsck /dev/md9" - if there are errors, stop here.
6/ "resize2fs /dev/md9"  (which will make use of all available space)
 only continue if you are really sure /dev/md9 looks good
7/ mdadm --zero /dev/sdc9
8/ mdadm /dev/md9 --add /dev/sdc9
9/ wait for resync to complete.

NeilBrown

>
>
> --=20
> David C. Rankin, J.D.,P.E.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloWCkACgkQOeye3VZi
gbmthg/+J1jEOs32e25t9ZqnqBT7cZLUyFFuR/F+9n0yuT4vKQJ4yqJSFYOUXjrt
3CO4fDgSVais0Bz5r8B9+Gwqg7c60c9dHvOGNdCzwvJF25F+QpLe2x4o6e6rq00p
62mZlHvL7tXX7WJI+mXREpfOjnzIYM8JEm7QHcSPhNlixorYQBNU8Tnriojnkusw
Q/bwXcE8NiEbH7Hz8qkf35ClzNQ9mrNete/+hiQYVEtRAETWwDi9l7gNyKIN9VRf
IZnS/zfellbJjHPg/Ztxuu36qSqNfcxiRbVveVS8VC/FiuSyg6/jg5BBn43TzZdQ
iljf7OmlxLO0/xuc8iUChI7AHQq8J81IkmKTux0PLrcRqwHb0ZXWcYhPgt4MfOgq
coT1FGK5y/P8q1flYVtGSXEpD1qaNYrCounQ4oybo1/n50mOycIOdqsLkSHSDTYu
baLYRLD3abj49z1JxTcsMcMeYDvL6a29H9AvuPD2yyqwARN9iBrJpKrn3Zf9Skly
g5JtW2Sx69GoZUXQ+WZX5wBjefQtLIsLrgCeZRhxcCBoyxOgUYlz2/P02SxWCjRs
kBMDMtvSm6VTEOI/njMRUoHondML2hu5Bag5DzOe/y+8GC+SA28njSJpGmBg0ZQW
3W1DXe9sX3A8wnTGA6Xhg8W8eNjzdcPAl966YhjZSWnM6VRhbxs=
=D3jS
-----END PGP SIGNATURE-----
--=-=-=--
