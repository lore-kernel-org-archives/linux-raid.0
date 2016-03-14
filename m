From: NeilBrown <neilb@suse.com>
Subject: Re: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Mon, 14 Mar 2016 12:08:06 +1100
Message-ID: <87r3fdx3wp.fsf@notabene.neil.brown.name>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com> <874mcglcsd.fsf@notabene.neil.brown.name> <CAOS+5GEu0xku0bjf=SAbx8=bkjn33wLg-1c1YK4DK5fOs_QhTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEu0xku0bjf=SAbx8=bkjn33wLg-1c1YK4DK5fOs_QhTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Mar 12 2016, Another Sillyname wrote:

> Neil
>
> Thanks for the insight, much appreciated.
>
> I've tried what you suggested and still get stuck.
>
>>:losetup /dev/loop0 /tmp/foo/sdb1
>>:losetup /dev/loop1 /tmp/foo/sdc1
>>:losetup /dev/loop2 /tmp/foo/sdd1
>>:losetup /dev/loop3 /tmp/foo/sde1
>>:losetup /dev/loop4 /tmp/foo/sdf1
>>:losetup /dev/loop5 /tmp/foo/sdg1
>>:losetup /dev/loop6 /tmp/foo/sdh1
>
>
>>:mdadm --assemble --force --update=revert-reshape --invalid-backup /dev/md127 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6
> mdadm: /dev/md127: Need a backup file to complete reshape of this array.
> mdadm: Please provided one with "--backup-file=..."
> mdadm: (Don't specify --update=revert-reshape again, that part succeeded.)
>
> As you can see it 'seems' to have accepted the revert command, but
> even though I've told it the backup is invalid it's still insisting on
> the backup being made available.
>
> Any further thoughts or insights would be gratefully received.

Try giving it a backup file too.
It doesn't matter what the contents of the file are because you have
told it the file is invalid.  But I guess it thinks it might still need
a file to write new backups to temporarily.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW5g72AAoJEDnsnt1WYoG5A4cP/A9UuQvKMIJuqfAGDeCtB9VD
bpO6bfl7HLOzleKqIoEuygH+hYzzSIr4bGzbFgIxClTvk6Ebdkpfw3Vf47Hycflp
hpO0/a6opB9dUsrYCsu0YwlaEMTGaMPfBlmh6swb9VDEvEORv55GfPbKkw6HfYQh
7O54rFBV+OHODC15m6+5/+7yS9l81VvEO5yexURBbA3dVznnGSUSZFWMQzta6Z2L
4lkU3nATLa3l3feTebx5QQ8SS1v5K3ebt3qtjMQfM3yyyl5z92/OdeTPw/i77GoE
j/RSiyO8DmWljvv5yqcvBjDEZm+aKNjoO0R4zwTvnaV5jez8R2XUfwNQ62HNGTRm
6Lre4gLyiJiBDBH6Dg9BapOAcZbQL1uCIpTZFR+CrsprT0CB8C/L9zV80xNpi9G0
gdV8/Ub0cDA4zEohEx+qmBFxj09wPdIQL3hdBUHMOx1LKNNlqB52ie94usw3T2XA
u82z9Mqo0ghuZ3gmjNYUNcY05xRAryn36QJ2LQAWyIxw+u3e2+KUfywGzGx1piy/
5FNcV8g8rVYDTnDtTm/SGKAJEmBj1Le5dJpvmSHnQFOXp/yWW/9f/dAIbGew/87x
uipXAip4SeEh2je7ErB6mMl5980zZhdC5bWp9ObOTDu7upS/9cr2XDqhReJsTWnC
ya+OORpARCc/SKH1FNcA
=skE5
-----END PGP SIGNATURE-----
--=-=-=--
