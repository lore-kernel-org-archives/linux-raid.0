From: Brice Figureau <brice+lklm@daysofwonder.com>
Subject: Same UUID for every member of all array ?
Date: Thu, 12 Apr 2007 14:57:57 +0200
Message-ID: <1176382677.14496.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

While I was trying to understand while an old server (which was happily
running linux 2.6.16 without initrd) was not booting anymore after a
migration to Etch and a new kernel (2.6.20.6 with initrd), I found the
following issue:

$ mdadm --detail --scan
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md8 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md7 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md6 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md5 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md4 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md3 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md2 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=6b8b4567:327b23c6:643c9869:66334873

As you can see, all the UUIDs are the same, and indeed there is no
possibility for mdadm to assemble such arrays as it uses the UUID to
find matching members.

Now, I don't know why all the UUID are equals (my other machines are not
affected).

Is there a possibility to "hot" change the UUID of each array (and
change the corresponding superblocks of each member) so that my next
boot will work ?

I'm not subscribed to the list, so please CC: me on replies.

Thanks,
--
Brice Figureau

