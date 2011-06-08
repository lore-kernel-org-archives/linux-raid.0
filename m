From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Growing a RAID-0 "internally"?
Date: Wed, 8 Jun 2011 13:34:06 -0700
Message-ID: <BANLkTi=kM_3Aadv7Y8ime2MGgPEJL_+7Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi. =A0I have a RAID-0 striped across two partitions; let's call them
/dev/sda2 and /dev/sdb2 (equal size). =A0These partitions do not stretc=
h
to the end of the respective drives; that is, there is also a
/dev/sda3 and /dev/sdb3 (also equal size).

I want to delete partitions sda3 and sdb3, resize sda2 and sdb2 to
consume the additional space, and then grow my RAID-0 array to use it.

I know how to perform every step (e.g., modifying partition tables,
resizing the file system) except for one: =A0How do I use mdadm to
change the size of the drives inside the RAID-0 array? =A0Or is this no=
t
supported?

Thank you.

=A0- Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
