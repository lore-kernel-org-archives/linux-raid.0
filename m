From: "Potthoff, Kay" <Kay.Potthoff@fci.com>
Subject: Q: How does raid1 sync if superblocks are dirty?
Date: Mon, 16 Sep 2002 16:59:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <9CFB9DA5261CD611A29B00508B7890486543B8@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Linux RAID Mailing List (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have oberserved a little bit obscure behavior of my RAID setup if my
system=20
comes up after a reset. I have setup a mirror and if I start the RAID a=
fter
a=20
reset MD detects that the superblocks on the disks are not clean and st=
arts
a=20
resync.

If I check the output MD tells me that both disks of the mirror are
operational;
the same if I look at the output of /proc/mdstat: both disks are operat=
ional

"... [2/2] [UU] ...". But a resync is still in progress.

My question is: In which direction the resync is done; resp. what is th=
e
sync algorithm in that case?

The kernel version is 2.4.10 (md driver 0.90.0).

regards, Kay

######################################################
# Kay Potthoff              Senior Software Engineer
#
# FORCE Computers GmbH        Tel.: +49-89-60814-356
# Lilienthalstrasse 15        FAX : +49-89-6097793
# 85579 Neubiberg/M=FCnchen
# Deutschland/Germany
#
# mailto:Kay.Potthoff@fci.com
######################################################
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
