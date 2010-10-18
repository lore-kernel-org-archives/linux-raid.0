From: Janek Kozicki <janek_listy@wp.pl>
Subject: booting into /dev/md0 after an upgrade to squeeze
Date: Mon, 18 Oct 2010 20:14:48 +0200
Message-ID: <20101018201448.62a76ba6@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I just upgraded my backup server to debian squeeze. It was
etch->lenny->squeeze upgrade.

And now I'm unable to boot into /dev/md0. It seems that grub is
identifying root by uuid of an ext3 filesystem which was on /dev/md0.

Before upgrading (etch to squeeze) I made a backup copy of /dev/md0
into another partition, which resulted in duplicating its uuid.

I had reboots in meantime after I finished lenny upgrade, and those
reboots worked.

But after finishing squeeze upgrade I could not boot into /dev/md0,
but instead I kept landing on the backup copy of /dev/md0 (which was
done before upgrade, and was containing etch). I verified with dmesg,
by looking at kernel command line that root=uuid=(uuid of ext3 filesystem).

And so, I changed uuid of that backup copy partition, so that the
original one /dev/md0 would be only one with such uuid. In the end -
I am unable to boot into it.

This server is remote, so it simply stopped starting up. I'll go
there and see myself, maybe selecting with keyboard another entry in
grub2 will be just enough.

But, maybe do you have some experience with booting into raid1 /dev/md0
after upgrading to squeeze?

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
