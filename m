From: Wols Lists <antlists@youngman.org.uk>
Subject: Linux raid wiki - setting up a system - advice wanted :-)
Date: Sun, 25 Sep 2016 22:16:24 +0100
Message-ID: <57E83EA8.9060809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a great way for learning lots about raid :-)

I'm planning a section on setting up a new system, and I need to know
what will happen if you give entire drives to mdadm.

Does it leave the first 2 megs empty? Basically, what I'm asking is if I do

mdadm --create /dev/md/bigarray -add /dev/sda /dev/sdb /dev/sdc

(note I am passing the entire drive, not the first partition) and then I
install grub on those drives, will I trash the array?

Cheers,
Wol
