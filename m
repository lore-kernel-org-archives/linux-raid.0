From: Andre Majorel <aym-xunil@teaser.fr>
Subject: RAID1 root and swap and initrd
Date: Fri, 15 Dec 2006 18:56:30 +0100
Message-ID: <20061215175630.GA11400@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pardon the probably silly question but...

Can you use RAID1 devices for your root and swap with a "straight"
kernel ? (i.e. without the need for initrd/initramfs.)

If that matters, the boot manager would be LILO and each MD device
would be assembled from "parallel" logical partitions.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
