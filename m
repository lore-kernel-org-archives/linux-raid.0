From: CoolCold <coolthecold@gmail.com>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 19:30:43 +0300
Message-ID: <AANLkTi=+kcLzThUfUjze-DtzH77srWoMkDYkHymAKRsP@mail.gmail.com>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
	<20110111141620.GE15871@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111141620.GE15871@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: Richard Grundy <richguk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 11, 2011 at 5:16 PM, Jan Kasprzak <kas@fi.muni.cz> wrote:
> Richard Grundy wrote:
> : Hi,
> :
> : I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
> : would like to know the=A0benefits of creating an LVM on top of this=
 are
> : instead of just creating the filesystem on the md directly. I've ne=
ver
> : had a problem growing the array and then resizing the filesystem
> : before and wondered if in this situation the only gain would be lvm
> : snapshot stuff? I'm planning to use ext4 for this array, if that ma=
kes
> : any difference.
>
> =A0 =A0 =A0 =A0The disadvantage of lvm over md is that with LV filesy=
stems
> usually cannot see the physical layout and determine the correct
> level of parallelism (like swidth in XFS, stripe in ext4).
XFS (xfsprogs) does this without any problems (for me at least)

>
> -Yenya
>
> --
> | Jan "Yenya" Kasprzak =A0<kas at {fi.muni.cz - work | yenya.net - pr=
ivate}> |
> | GPG: ID 1024/D3498839 =A0 =A0 =A0Fingerprint 0D99A7FB206605D7 8B35F=
CDE05B18A5E |
> | http://www.fi.muni.cz/~kas/ =A0 =A0Journal: http://www.fi.muni.cz/~=
kas/blog/ |
> Please don't top post and in particular don't attach entire digests t=
o your
> mail or we'll all soon be using bittorrent to read the list. =A0 =A0 =
--Alan Cox
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
