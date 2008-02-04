From: Moshe Yudkowsky <moshe@pobox.com>
Subject: using update-initramfs: how to get new mdadm.conf into the /boot?
 Or is it XFS?
Date: Mon, 04 Feb 2008 14:59:44 -0600
Message-ID: <47A77CC0.10807@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've managed to get myself into a little problem.

Since power hits were taking out the /boot partition, I decided to split 
/boot out of root. Working from my emergency partition,  I copied all 
files from /root, re-partitioned what had been /root into room for /boot 
and /root, and then created the drives. This left me with /dev/md/boot, 
/dev/md/root, and /dev/md/base (everything else).

I modified mdadm.conf on the emergency partition, used update-initramfs 
to make certain that the new md drives would be recognized, and 
rebooted. This worked as expected.

I then mounted all the entire new file system on a mount point, copied 
the mdadm.conf to that point, did a chroot to that point, and did an 
update-initramfs so that the non-emergency partition would have the 
updated mdadm.conf. This worked -- but with complaints about missing the 
file /proc/modules (which is not present under chroot). If I use the -v 
option I can see the raid456, raid1, etc. modules loading.

I modified menu.lst to make certain that boot=/dev/md/boot, ran grub 
(thanks, Robin!) successfully.

Problem: on reboot, the I get an error message:

root (hd0,1)  (Moshe comment: as expected)
Filesystem type is xfs, partition type 0xfd (Moshe comment: as expected)
kernel /boot/vmliuz-etc.-amd64 root=/dev/md/boot ro

Error 15: File not found

Did I miss something? I'm pretty certain this is the procedure I used 
before. The XFS module is being loaded by update-initramfs, so unless 
there's a reason that I can't boot md from  a boot partition with the 
XFS file system, then I don't understand what the problem is.

Comments welcome -- I'm wedged!


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"Many that live deserve death. And some that die deserve life. Can you 
give it to
them? Then do not be too eager to deal out death in judgement. For even the
wise cannot see all ends."
				-- Gandalf (J.R.R. Tolkien)
