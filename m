From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: invalud argument when replacing disk of raid 5 set
Date: Sat, 8 Nov 2003 16:24:50 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-boj5ci$leu$1@cartman.spoiled.org>
References: <3FAC523E.3050509@eglifamily.dnsalias.net>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Egli <dan@eglifamily.dnsalias.net> wrote:

> I have a machine with a 3 disk raid 5 set. One of the disks has 
> developed bad sectors in the parity block (I'm assuming it is in the 
> block because badblocks /dev/hdb shows bad areas, badblocks /dev/md0 
> does not), which causes it to randomly get kicked out of the set. I got 
> a drive to replace it with today. It's not the exact same model, but 
> it's the same physical dimentions (C/H/S & capasity are identical). It's 
> just a little faster than the others, with a little more cache on the 
> drive. But when I repalce the bad drive with the good drive, I get 
> invalid arguments when trying to bring up the array. I don't get it. 
> There is a perfectly valid linux partition on the drive, /dev/hdb1 which 
> meeds the same specs as /dev/hdc1 and /dev/hdd1, but replacing hdb with 
> a drive showing no bad blocks won't work.

What commands do you exactly type and what error messages do you
exactly get?

Juri

-- 
Juri Haberland  <juri@koschikode.com> 

