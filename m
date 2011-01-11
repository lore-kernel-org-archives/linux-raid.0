From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 15:16:20 +0100
Message-ID: <20110111141620.GE15871@fi.muni.cz>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Grundy <richguk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Grundy wrote:
: Hi,
:=20
: I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
: would like to know the=A0benefits of creating an LVM on top of this a=
re
: instead of just creating the filesystem on the md directly. I've neve=
r
: had a problem growing the array and then resizing the filesystem
: before and wondered if in this situation the only gain would be lvm
: snapshot stuff? I'm planning to use ext4 for this array, if that make=
s
: any difference.

	The disadvantage of lvm over md is that with LV filesystems
usually cannot see the physical layout and determine the correct
level of parallelism (like swidth in XFS, stripe in ext4).

-Yenya

--=20
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - privat=
e}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18=
A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/bl=
og/ |
Please don't top post and in particular don't attach entire digests to =
your
mail or we'll all soon be using bittorrent to read the list.     --Alan=
 Cox
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
