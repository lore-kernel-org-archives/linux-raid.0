From: danci@agenda.si
Subject: 2.2 kernel, SW raid and ext2resize question
Date: Thu, 12 Feb 2004 15:04:27 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402121454540.5974@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have a server, that is in production use. It has a Mylex HW RAID card 
with 4 arrays configured. Two of them are used for / and /boot, one is for 
data and one is still unused (this one uses a 2nd set of disks).

The array holding the data is getting full and I have to figure out a way
to expand the size of it - WITHOUT loosing data! While backups are
available, it would take too long for 252G to restore...

The server is running 2.2.19 kernel without LVM support. I can compile a
new kernel to include stuff needed - SW RAID, etc...

I know one can resize ext2 with ext2resize package. So what I need to do 
is figure out how to 'join' the two arrays without losing data.

If I create a software RAID 'linear' array, made of two Mylex arrays (1st
the one with the data, 2nd the unused one), what are my chances to keep
the data intact and just resize the existing ext2 filesystem?

What are my other options?

 Thanks, Danilo
