From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Force RAID1 as clean
Date: Tue, 06 Jan 2004 03:13:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xn091zuwy.fsf@ford.guide>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is there a way to forcibly mark a RAID1 as clean?  I know it can be
dangerous, I just don't want to wait for 200GB of scrap to resync.

=46or some reason, the resync is terribly slow in Linux 2.6.0, only
~1MB/s.  DMA is enabled on all disks and the individual performance of
each disk is normal.  There are no error messages from the kernel.  It
just doesn't seem right.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
