From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: RAID4 and RAID5 Code
Date: Thu, 14 May 2009 22:27:27 +0530
Message-ID: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Looks like we have the same code for RAID 4 and RAID 5, I could see
the same make_request for both.

Can someone point me in the code, where exactly we differentiate
between these two. i.e updating checksum block, etc.


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
