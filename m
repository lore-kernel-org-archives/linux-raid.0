From: Roberto Spadim <roberto@spadim.com.br>
Subject: raid10 - without stripe
Date: Tue, 22 Feb 2011 16:17:08 -0300
Message-ID: <AANLkTimf64aT9smXdhvcGWLAo09Evn4sQ8KDbbB54W49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys, on old email, some one told me that was possible using raid10
with layouts, and without stripe
could i make a 2disks raid10 with layout?
i tried many commands but couldn=B4t work without stripe (disk grow
after each mdadm --create i made :/)
can anyone help? i want faster aligned reads (like raid0) but without
growing my disk size (i want only mirrors)

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
