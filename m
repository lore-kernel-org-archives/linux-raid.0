From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/9] raid5-cache fixes
Date: Wed, 14 Oct 2015 08:03:10 +1100
Message-ID: <878u76zdkh.fsf@notabene.neil.brown.name>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Shaohua Li <shli@fb.com> writes:

> Hi,
>
> some fixes for raid5-cache/md. Mainly supports trim, handle IO error and
> handling array assemble with missing/faulty disks.
> patch 1: fix a bug
> patch 2: support trim
> patch 3-4, IO error handling
> patch 5-9, handle assemble issue when journal disk is missing/faulty
>
> If there is IO error to journal disk, write IO will fail immediately. If we
> assemble an array with journal feature enabled but with journal disk
> missing/faulty, the raid array will start readonly.
>
> Thanks,
> Shaohua
>
> Shaohua Li (6):
>   MD: fix info output for journal disk
>   raid5-cache: add trim support for log
>   raid5: journal disk can't be removed
>   raid5-cache: IO error handling
>   raid5-cache: start raid5 readonly if journal is missing
>   MD: set journal disk ->raid_disk
>
> Song Liu (3):
>   MD: add new bit to indicate raid array with journal
>   MD: kick out journal disk if it's not fresh
>   MD: when RAID journal is missing/faulty, block RESTART_ARRAY_RW
>

Thanks,
I've applied all of these.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHXGOAAoJEDnsnt1WYoG5vRUP+gJ36VDySofqbxSrh8HkJupE
osM4Gtce+B8ES/Z4aZJkENglCLU6Kcu3xcVDAJzEZC+P8VWpAC8QEmROC9UMdeJ3
trvEUVc9Xz5sM3oaOJNZZLQI9FtD0n+C/ZiWWMSA9rDnWllEXIfFDLgF8UBgv8EF
xNnvZJiguh34Gi1PofNiPPnHl6pjQC0tJjrRDWjPMmgPIMB1EXrEE0FRoEbRxh2h
sK41+kPxWYoE0GnM1BFbxVqtH577dEX7tbBbpQNl5gCBjB9oCSGgyM6jwLcNjBcY
Snjwcy1YN6CNqZ3UBEDfNXDiClLC2SLqfZ48qjGvLbrLqCIOUalaCXGo/+LCxMKc
Pxh+8KWNSZFeh0RRird0SAspRn0SEk55J1YLRbfm2E0d/X+TGOyjYD89XdwCxOWX
n5OhFQ6pMKa0GwdjfyUUcgGAcCshq/PO9AA9TJPVKVbuCLEd9xN/bumCy+JxdXyQ
jvtHc27yo8wvBn60KoxD9Jqjb8IkO3y+A7TnGis/4OiejbVPVlUDJ9Wr04apQMZK
ORWmnePajqNBzJjs28Pdhylt6eIvYlDzyEFIcxDCQopeORTpsJkmVEGvfYcuCgLF
ihavsezUKoeIJLSBoDd/A8dmRTVwS/PCDlt+CIZEw8yfshw7wbVK/EN3SBLdNmb1
005bgXLn1uYKMpEw7qoU
=tMgO
-----END PGP SIGNATURE-----
--=-=-=--
