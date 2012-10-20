From: Ken <ravenpi@gmail.com>
Subject: Dead three-disk RAID-5. Help?
Date: Fri, 19 Oct 2012 23:19:42 -0400
Message-ID: <CAHw0J8hx+_siPsd7ZQN=WKy2yTpiSzyKk1ULUKa+HBbEwsy8pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm currently highly suspicious that I executed the wrong command in
the wrong window -- which would mean that I blew away the partition
table, and fsck'd the new partitions, on /dev/sda.  Which
theoretically leaves me with /dev/sdb and /dev/sdc, no?  Except that
when I try to access them, it won't allow me to create the array.  If
I try the whole thing, it either tells me there's no partition table
on /dev/md0, or that it can't find the superblock on /dev/md0.

Any pointers on where to go from here would be very much appreciated
-- as (of course) the irony is that the system I *meant* to be
fsck'ing was intended to back up the original system.

Thank you kindly,

-Ken
