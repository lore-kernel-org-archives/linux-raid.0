From: Mike Smith <easygreenus@yahoo.com>
Subject: mdadm HOWTO
Date: Sat, 26 Nov 2005 22:09:34 -0800 (PST)
Message-ID: <20051127060934.53663.qmail@web51403.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been using mdadm for over a year now and really
like the utility.

Can someone point me to a howto type document that
shows how
to do various tasks.  Like recovering a metadevice.  I
suspect my situation is not unique and would probably
be
covered.

I have a mother board with 3 sata raid controllers.
I have two drives on the first that I use for the OS 
and a mirror of the OS using mirrordir.

I have two 250GB drives on the second sata controller
and
two on the third.  I have put these four drives in a
RAID5 metadevice ( /dev/md0 ) using mdadm.  I then use
LVM to slice/dice md0 into the various filesystems I
need.

I've run this way for over a year and now want to
upgrade my
OS.  I have been running Mandrake 10.1, and want to
move to
Mandrivia 2006.

My first problem is that my devices are renumbered
with the
new OS install.

                    Mandrake        Mandrivia
1st Controller        sda             sda
                      sdc             sdb

2nd Controller        sdb             sdc
                      sdd             sdd

3rd Controller        sde             sde
                      sdf             sdf

Originally,  I created the RAID5 device using sdb,
sdd, sde, and sdf.
Under Mandrivia,  I was successful in using mdadm to
assemble a
RAID5 device, but trying to mount the filesystems (
/dev/vg1/video )
it said they did not exist.

I can reboot under my original Mandrake 10.1 install
and everything
is still there.  So,  how do I recover these
filesystems under the
new OS?

Please reply to easygreenus@yahoo.com as I'm NOT on
this alias.

Thanks,

Mike



	
		
__________________________________ 
Yahoo! Mail - PC Magazine Editors' Choice 2005 
http://mail.yahoo.com
