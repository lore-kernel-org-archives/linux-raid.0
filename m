From: NeilBrown <nfbrown@novell.com>
Subject: Re: Recovery after failed chunk size change
Date: Fri, 01 Apr 2016 16:25:24 +1100
Message-ID: <87a8ldrjcr.fsf@notabene.neil.brown.name>
References: <56FD7B92.1030102@ferienwohnung-altenbeken.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56FD7B92.1030102@ferienwohnung-altenbeken.de>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Meier <maillists@ferienwohnung-altenbeken.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 01 2016, Benjamin Meier wrote:

> Hi there,
>
> I tried to do a chunk size change from 4096k to 64k on a 7-disk RAID6=20
> array. I am using Debian Jessie with kernel 3.16 and mdadm 3.3.2. After=20
> I initiated the change the process staled immediately. I could watch it=20
> in /proc/mdadm that there has not been any progress at all. The=20
> backup-file hasn't been touched for days now.
>
> So I decided to backup all data from that device in case it isn't=20
> starting at next reboot. Accidentally the system was restarted before=20
> the backup was finished. And now the array is not assembling any more,=20
> even with the correct --backup-file. I get "mdadm: Failed to restore=20
> critical section for reshape, sorry.".
>
> So the first question is: How can I access the data again? I think there=
=20
> is no damage at this time- I appended an output from --examine at the=20
> end of this message. All seven drives giving me the same output in all=20
> relevant topics. Especially "Chunk Size", "New Chunksize" and "Reshape=20
> pos'n" is all the same.
> What is the best way now that I do not damage any data?

 mdadm --assemble --force --update=3Drevert-reshape --invalid-backup
 --backup-file=3D/whatever /dev/md/TA /dev/list-of-devices

using mdadm 3.4.

>
> Second question: Is the problem with the level change a known bug?

Yes, this has been happening to a few people.  The shape doesn't really
start properly.
If someone can provide a recipe for how to reproduce the problem
(e.g. using loop-back devices) I'll happily look into fixing it, or
identifying which kernel it is already fixed in.

Neilbrown


>
> Thanks for reading!
>
> --
> /dev/disk/by-partlabel/hyper_TA_1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>             Name : hyper:TA  (local to host hyper)
>       Raid Level : raid6
>     Raid Devices : 7
>
>   Avail Dev Size : 3434725376 (1637.80 GiB 1758.58 GB)
>       Array Size : 8586813440 (8189.02 GiB 8792.90 GB)
>      Data Offset : 147456 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D147368 sectors, after=3D0 sectors
>            State : clean
>
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 0
>    New Chunksize : 64K
>
>      Update Time : Thu Mar 31 17:57:01 2016
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : e7172c1f - correct
>           Events : 527046
>
>           Layout : left-symmetric
>       Chunk Size : 4096K
>
>     Device Role : Active device 5
>     Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/gZEAAoJEDnsnt1WYoG5vUkP/RY4sdxGPuP98B8mhObN8mJX
p2dIposqWjjurvJGZzLC9xmyl3XRM+bHaHEd4hm34+bOhA+OkEeheVr+gj9I+oT/
CKtsEAuRMdQvwDqEQD3xxVjv57An5J6nRuZRz/lMv27NZhAc3bdhsb4BzIgZ6plp
CKzJuurZFxxZLBVnFnlqKsmZuxcxnXIWHqCRLDB7eerxGN2KXnG1Jssbh1QIjbuu
WVrz6PkHeaWTv79GQOmqGy+9zwDMvMx0M8y3njG7/FGF5zxpP29InpF/QdEt44Bi
nXlC/FQlbsymem+13Zder0nhsaqSwy0HRlWdcW/ZCcIprfdU4tMffRfpDi4ZEj1j
38tNpJ9eej2v8eo173tS0ib7u3dSmOwPO0r9S7JK45z9M2Q235nD0k2upKgDuYUE
L4wx7WX7lMo4WEGwqvLjti2rT66qcTkUsFSlyjOezW9q77Dm9b/wXoifrGdRCZsG
hyVnr1OJ30qjvlEOne4Cupqsh74Ko84K73fAxpdQUu5ULY2R9ZFT4LwVHpmJGQly
n46SwAZKqeQrSWbNlVbWHK9DHrpSgtckMdpzBNqQ7ikYW5GuXKkQu36/TmP8F1Yy
1LwGNjZSPzZ/1sr2tT/mfX6YgPJiK++4u+FdGptCjnVhxbyR7BI0Ke4r0VmNE7Ih
jbBL0kt9ZRdE0e78S554
=1TwQ
-----END PGP SIGNATURE-----
--=-=-=--
