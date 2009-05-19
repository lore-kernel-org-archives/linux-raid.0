From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: [PATCH] md: Enhancements and clean to linear RAID
Date: Tue, 19 May 2009 11:53:53 +0530
Message-ID: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I have made the desired changes and have tested the changes as well.
As expected the performance gain with number of devices ( > 20 ) is
quite visible.
The code also looks simpler as compared to what it earlier was.

I have created the following patches for the changes:

PATCH [01/03] md: Removal of num_sectors from dev_info in linear raid

This patch removes the num_sectors from dev_info and makes use of the
rdev->sectors for
all further usage.

PATCH[02/03] md: Getting rid of sector_div and hash table in linear rai=
d

Removal of all the code pertaining hast table and other related data st=
ructures.
This also makes the code really really simple.
The searching being made linear for the time being to test the patch.

PATCH[03/03] md: Replacing linear with a binary search

This patch replaces the linear search in which_dev with binary search.

The patches will follow this mail.


--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
