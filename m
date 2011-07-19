From: Shaun Reich <predator106@gmail.com>
Subject: Raid5 boot failure after grow
Date: Tue, 19 Jul 2011 18:43:50 -0400
Message-ID: <CADVynFA9NffR7jMrN5HV05n9V0=SOVdyFQjvCvNP=MU+G-ur6g@mail.gmail.com>
Reply-To: shaun.reich@kdemail.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm using Fedora 15 and I added an additional disk to my raid5 setup
and grew the array to encompass it. It all worked fine and rebuilt and
everything. However, now when I boot my computer I am dropped to a
shell, stating "dracut" (I wonder what that means). Anyways, when in
here I can cat /etc/mdadm.conf and it appears to be an old
configuration file. It lists only 3 raid devices in that
configuration. I now have 4.

If I run mdadm --assemble --scan after removing the config file, it
will automatically find my array and all is well. But this doesn't
solve the fact that it doesn't boot to it.

dmesg reports "no root device
'block:/dev/disk/by-uuid/933ac67-98f1-481f-934e-c9af492ba28c' found"

This is particularly interesting, because blkid lists /dev/md127
(after I've managed to mount it), as that same UUID.

fyi, I use GRUB to boot to a /boot partition, which is then supposed
to mount the array. Is there anything obvious that I have missed? Do I
have to rebuild the initrd, or something like that? (since it seems
the fallback shell doesn't preserve any changes to /etc/mdadm.conf).

Let me know if more information is needed.

-- 
Shaun Reich,
KDE Software Developer (kde.org)
