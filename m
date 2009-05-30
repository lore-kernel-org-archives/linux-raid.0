From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: RAID5 reconstruction ?
Date: Sat, 30 May 2009 11:14:33 +0530
Message-ID: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Say If I have a RAID 5 array of 50GB of five disks of 10GB each.

I have data of 5GB. When a disk fails and replaced with a spare disk.
Will the reconstruction happen only for the 5GB allocated disk blocks
or it will happen for the whole disk size.


Is it possible to make  reconstruction intelligent enough to keep it op=
timized ?

Thanks.

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
