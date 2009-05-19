From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: linear raid : mddev not protected in linear_add
Date: Tue, 19 May 2009 17:53:48 +0530
Message-ID: <37d33d830905190523l1ae7536al83ed1255cba3050d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

In linear_add( ), the mddev is gets changed.
Don't we require to lock/unlock around mddev inorder to avoid races?



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
