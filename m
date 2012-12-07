From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [Q] md: Why mddev->pers->status() '[2/1]' -  degraded in second value?
Date: Fri, 07 Dec 2012 18:51:42 +0100
Message-ID: <50C22CAE.1020505@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

can somebody answer the question why in /proc/mdstat the degraded count
is used in the second parameter and not in the first of the string "[2/=
1]"?

Here is the related code:

from raid1.c:
	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
		conf->raid_disks - mddev->degraded);

In the other personalities it is the same. For me it would make more
sense to see that I've got "[1/2]" (one of two) active.

I couldn't find the explanation in "Documentation/md.txt".

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer - Storage

We are looking for (SENIOR) LINUX KERNEL DEVELOPERS!

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer@profitbricks.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
