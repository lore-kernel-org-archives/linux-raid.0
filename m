From: "Thomas Hicks" <thicks@speedfreak.org>
Subject: Mdadm issue
Date: Mon, 1 Jul 2002 14:04:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006801c22142$d28ed790$2500010a@speedway.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the first time I am setting up raid using the mdadm tool. This
is what I am trying to do. 

The sever is as follows: 2 drives at 10gig
                         2 drives at 80gig
hda2 is /
hdd1 is my /home

I have the other drives in ad ready and would like to set up the 2 10
gig's as a mirror and the 2 80 gig as raid0

At the shell I run this command 

mdadm --create /dev/md0  --level=1 --raid-disks=2 /dev/hda2 /dev/hdb1
and get the following output:

mdadm: /dev/hda2 appears to contain an ext2fs file system
    size=7269412K  mtime=Mon Jul  1 11:56:16 2002
mdadm: /dev/hdb1 appears to contain an ext2fs file system
    size=7333640K  mtime=Mon Jul  1 11:56:29 2002
Continue creating array? y
mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists

Could someone please help me with this problem. I am having a really
hard time finding any info on the web about this. 


