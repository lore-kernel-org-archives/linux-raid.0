From: "Guenter Alland" <guenter_alland@utanet.at>
Subject: PLEASE HELP ME - DATA LOST?
Date: Tue, 23 Mar 2004 01:42:59 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1140.212.152.201.167.1080002579.bloek@pwebmail.utanet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
I think I've got a big problem:

After a disk crash I wanted to make a new RAID1-Set.

The Original Data was on /dev/hda4 (reiserfs) and the empty harddisk wa=
s
/dev/hdc1.
But I forgot that there was one new directory left, call "test".

After I had initialized the new RAID1 set I recognized that this direct=
ory
was newer than the other partition.

The result is now: ALL DATA LOST? - But as there was no transaction all
data should still be on /dev/hda4

IS THERE ANY NOWN POSSIBILITY TO RESCUE THE DATA??? Please help me beca=
use
about 20 GB would otherwise be lost forever. Almost a catastrophy becau=
se
a part of my master-thesis is in there!

IS THERE ANY CHANCE?

THANK YOU VERY MUCH!
G=FCnter


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
