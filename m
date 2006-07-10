From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 14:07:18 +0200
Message-ID: <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>
References: <loom.20060709T205013-455@post.gmane.org>
	 <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
	 <loom.20060710T095111-275@post.gmane.org>
	 <44B213CD.5010907@idgmail.se>
	 <loom.20060710T112944-980@post.gmane.org>
	 <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>
	 <loom.20060710T132722-427@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060710T132722-427@post.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <news@karl-voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
> OK, I upgraded my kernel and mdadm:
>
> "uname -a":
> Linux ned 2.6.13-grml #1 Tue Oct 4 18:24:46 CEST 2005 i686 GNU/Linux

That release is 10 months old.
Newest release is 2.6.17.
You can see changes to MD since 2.6.13 here:
http://www.kernel.org/git/?p=linux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.17.y.git&a=search&s=md%3A

Anything from 2005-09-09 and further up the list is something that's in 2.6.17 but not in 2.6.13.

For example, your MD does not have sysfs support, it seems...


> "dpkg --list mdadm" --> "2.4.1-6"

Newest release is 2.5.2.
2.4.1 is 3 months old.

> Is it true, that I should try the following lines?
> 
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/sda
> mdadm --zero-superblock /dev/sdb
> mdadm --zero-superblock /dev/sdc
> mdadm --zero-superblock /dev/sdd
> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 --force
> (check, if it worked - probably not - and if not, try the following line)
> mdadm --create -n 4 -l 5 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

I don't have a unix box right here, but yes, that looks correct to me.

You can make certain that the ordering of the devices is correct by looking in your paste bin, lines 12-15.
Other RAID parameters (raid level, # of devices, persistence, layout & chunk size) can be seen on lines 212-231.


> Did you mean something like "echo repair > /sys/block/md0/md/sync_action"

Exactly.
(Gee, I hope someone stops me if I'm giving out bad advice.  Heh ;-).)

You can also assemble the array read-only after recreating the superblocks, and you can use "check" as a sync_action...

But only if your kernel has MD with sysfs support ;-).
