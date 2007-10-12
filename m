From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: RAID6 recover problem
Date: Fri, 12 Oct 2007 16:42:07 +0200
Message-ID: <8F1D6256-0F63-4B79-8D66-87EFB96DFD6A@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 10 disk raid6 with internal write intent bitmap here =20
(softraid, build and managed via mdadm). For whatever reason one of =20
the 3 promise SATA 300 TX controllers went offline and took 4 of =20
these 10 disks with it. After reboot the array was assembled with 8 =20
out of 10 disks - sda2 and sdb2 missing. When I tried to re-add sda2 =20
sdc - which is one of the "active" disks - reported a read error on =20
sector 54631. Ok - seems I have a problem.

I stopped all activities at this point to ask here what I can do to =20
reassemble the array with a minimum loss of data.

Except the offline disks sda2 and sdb2 all other disks report 19 =20
dirty chunks (mdadm -X). The offline disks report 7 dirty chunks.

If one needs any further data - just ask.

Hoping for assistance
Ralf M=FCller



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
