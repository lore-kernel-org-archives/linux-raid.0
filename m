From: Wols Lists <antlists@youngman.org.uk>
Subject: Moving root to raid, weird raid behaviour
Date: Mon, 22 Sep 2014 19:29:46 +0100
Message-ID: <54206A9A.8010308@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if this is weird raid, stupid grub2 or incompetent newbie,
but whatever ... and the system is my development/test system so if it
gets trashed it's no disaster, but I would like to understand what is
going on ...

Old setup
/ = sdb2
/var = sdc2
/home = mdX (sdb3, sdc3), mirror

I added sdd and made a new
/ = mdY (sdd3, missing) mirror
and added sdd4 to mdX
/home = mdX (sdb3 sdc3 sdd4)

Weirdo one - sdd4 mirrored and synced fine. Then I rebooted ...
mdX = (sdb3 sdc3 missing)
mdZ = (sdd4 missing missing)

wtf?!?!? - oh and both of them share the same uuid. The obvious (but it
shouldn't make any difference?) possibility is that sdb and sdc are
500Gb, partitioned identically. sdd is 1Tb, so sdd4 is twice the size of
the other two.

The other weirdo is I'm trying to migrate from grub/mbr to grub2/gpt. Of
course that's causing me fun, but I've managed to get the system booting
fine from mdY. Only snag is, when I list /dev, mdY isn't there! mount
shows it as mounted on / but that's the only place I can find it!

mdadm v3.2.6
kernel 3.14.14-gentoo

Any ideas what's going on? I've googled, but everything I find looks out
of date or not relevant.

Cheers,
Wol
