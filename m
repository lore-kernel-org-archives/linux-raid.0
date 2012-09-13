From: "vincent" <hanguozhong@meganovo.com>
Subject: raid5:bad sectors after lost power
Date: Thu, 13 Sep 2012 16:43:27 +0800
Message-ID: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone:
    I have a problem about raid5.
    I created a raid5 with the command =A1=B0mdadm =A8CCv --chuck=3D128=
 /dev/md0 =A8C
l5 =A8Cn4 sd[abcd]=A1=B1 for write performance test, the capacity of ea=
ch disk is
2TB. After the array was created, I modified the strip_catch_size of it=
 to
2048.=20
    Then I used a program to parallel write 150 files to the array, the
speed of each is 1MB/s. Unfortunately, the electricity went off suddenl=
y at
the time. when I turn on the device again, I found the raid5 is in reco=
very.
When     the progress of the recovery went up to 98%, there was a write
error occurred. I used =A1=B0smartctl =A8CA /dev/sd*=A1=B1 to check the=
 heath status
of these disks. I found the =A1=B0RAW_VALUE=A1=B1 of the attribute whos=
e name was
=A1=B0Current_Pending_Sector=A1=B1 of sda and sdb were 1.
=A1=A1=A1=A1Then I used =A1=B0HDD_Regenerator=A1=B1 to check if there w=
ere bad blocks in the
disks. The result of the output indicated that sda and sdb did have a b=
ad
sector.=20
    These disks were used for the first time after purchased. Is it nor=
mal
to have bad sectors? Could you please help me?=20


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
