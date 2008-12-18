From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Thu, 18 Dec 2008 23:19:28 +0100
Message-ID: <494ACC70.1040603@gmail.com>
References: <49402CFE.3080708@gmail.com> <18759.8246.568849.244513@notabene.brown> <494AC8BA.7010704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <494AC8BA.7010704@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tor Arne Vestb=F8 wrote:
> The original array had sd[bcde]1 + sdf1 as spare. Then sdb1 went miss=
ing
> and the spare kicked in, and then sdc1 went missing, leaving me with =
a
> degraded array.

=46YI, I decided to delete the Linux auto-detect partition on /dev/sdb =
so
I could re-create it and add /dev/sdb1 to the array again, so I at leas=
t
have four drives and not a degraded array (don't want to lose all my da=
ta).

This worked fine; after fdisk'ing /dev/sdb, deleting the partition and
recreating it with the same parameters is showed up as /dev/sdb1, and I
was able to add it to the array using mdadm /dev/md0 -a /dev/sdb1. The
array is now rebuilding.

We still have /dev/sdc1 as a test-case though, so the original problem
is still there, just not for two drives but for one. I would really lik=
e
to figure out why it's happening, so that suddenly it does not happen t=
o
two drives at the same time, rendering my array dead :/

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
