From: Magnus =?ISO-8859-1?Q?M=E5nsson?= <ganja@0x63.nu>
Subject: reconf raid
Date: Thu, 20 May 2004 11:13:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085044407.16167.5.camel@freya>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, I have just joined this list and made some reading.
What I am looking for is a way to add new hard drives to my raid5 made
with mdadm. If have got it right it's not supported, and it's taking
some time though people wants to do it in the kernel and not the way
raidtools-reconf does it, fully understandable (even though I would lik=
e
to do it offline).

So my question is, is there any timeplan for this functionallity? Can I
expect to be able to resize my raid5 before winter?

My idea was to build a lot of raid5 (like 5 of them) to match that my
hard drives have different sizes, and after that use lvm to get one big
partition that I can add new drives to and just enlarge.

This leads to that I also have to be able to convert raid1 to raid5, if
I do not want to move the data on that little part to a temporary disk,
that would be possible today, it would be only 70G to move around.

--=20
Magnus M=E5nsson <ganja@0x63.nu>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
