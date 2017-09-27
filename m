From: NeilBrown <neilb@suse.com>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Thu, 28 Sep 2017 08:38:59 +1000
Message-ID: <87tvzn6a2k.fsf@notabene.neil.brown.name>
References: <59C4D44A.7080302@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59C4D44A.7080302@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joseba Ibarra <wajalotnet@gmail.com>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 22 2017, Joseba Ibarra wrote:

> Hi.I have a RAID5 using 4 drives in a HO Proliant G8 Microserver
>
> I got a Proxmox installed and the disks for RAID are associated with a=20
> specific VM with Debian 9. It worked like a charm.
>
> But, some days ago i broke a proccess giving some permissions (sudo=20
> chmod....) to some folders into of the mounted /dev/md0. Then after=20
> restart the VM the RAID din't mount again. The raid contents very=20
> important data for me, so i'm not very sure what to do in order don't=20
> lose the data. So, i=C2=B4m getting bit panic.
>
> I need some guide to rebuild the system without losing the content.

Thanks for providing lots of useful data.

>
> root@grafico:/# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]=20
> [raid1] [raid10]
> md0 : active (auto-read-only) raid5 sdb1[0] sde1[3] sdc1[1] sdd1[2]
>        2929889280 blocks super 1.2 level 5, 512k chunk, algorithm 2=20
> [4/4] [UUUU]
>        bitmap: 0/8 pages [0KB], 65536KB chunk

It appears that md0 has been successfully assembled.  What does it
contain? What do you expect it to contain?  ext4? xfs? btrfs? LVM volume
??

What does "pvscan" show?
What does "fsck -n /dev/md0" show?
What happens when you "mount /dev/md0 /mnt" ?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnMKIUACgkQOeye3VZi
gbk1iBAApHjGPZSnMhSlL12YXwQKgS7UCwbg2llPGx2SsnAXYyl+7RHCzTgReTTj
Z7VQUrvjApO5wV1T/9kEwGgC+6n/QihfgBSeMgAMArhkky+2RecHqLC70Tg12uFf
B3UoaWsbs1wpPAgTiBmc0CpMJU/Vcjjz+PI4AjOyvJBk10kdZGEVg8CqwsTRBwnW
pN87VDfENNwj5mgZrnuggUzEkX+ga/bbb4cj2Q3Nq1223ZbKOAN4x4/veiZ5OPOI
Ov7FOtTC1m9FNwnOUeCQyP8FOt5bNcnkcu65FqAqFz4waTylbaNTV6G6VtlX7TdB
pdFv3wEF8VU2lubqSP/FJjV+25dRnGxI1tUheLN2NANC7u4zHcKkdifnGNonRDt1
KcUxmkHr9DUoAPIPW4HBLSZhGH5aAIeajdJdwZx8llZ67S57DGQgMw+i/pCFrYg1
pDTSyRQLek6sdrRSxqYPVl6jozeRC7XEglYcah9DiecxqVrNjNmVrusuPluNADme
Xq9Sg+rfjbCzzLmWRizFWp0bIO9i/fVYc+0HNiMwv6gehleL7dcAL9GhkFcCUKuw
JDYKMENnuuMmX3n9taqOskrFrlN+regyiZSXrU92zjGU0M8EL1Z1kLSS5AWpUUqp
EeGgAXsy7acSgkD+AeK8eNSRKi59iLaBtwTayhrPcK45kCMPFTY=
=9ZZE
-----END PGP SIGNATURE-----
--=-=-=--
