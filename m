From: Wols Lists <antlists@youngman.org.uk>
Subject: Interesting mount problem on openSUSE
Date: Wed, 12 Jul 2017 14:59:39 +0100
Message-ID: <59662B4B.3040504@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Not my problem !!! Seen on the opensuse mailing list - a current thread...

Somebody has created a v1.0 mirror, which mounts fine on openSUSE 12.2,
but not Leap 42.2.

The two drives making up the mirror are sdb9 and sdc9, and the array is
called md9.

The filesystem on md9 is the same size as sdb9 or sdc9. The guess is the
array was created, and then the file system was created on one of the sd
devices.

The weirdo is why 12.2 mounts the partition fine, but 42.2 won't. Has
collision checking been tightened up? Might there be a change in the
superblock where the filesystem has overwritten it in a manner 42.2 can
detect but 12.2 can't?

As I say, it's not my problem, and it's clearly an incorrect
configuration, but it's weird why the older distro has no problem but
the newer one won't mount it.

Cheers,
Wol
