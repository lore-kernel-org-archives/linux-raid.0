From: kernel@ddx.a2000.nu
Subject: fsck out of memory
Date: Fri, 7 Feb 2003 16:17:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i'm trying to run e2fsk after a system hang
after 1 hour running (70%) which had a memory usage for about 128M
i get these errors in the dmesg :

Out of Memory: Killed process 732 (fsck.ext2).
Out of Memory: Killed process 732 (fsck.ext2).
Out of Memory: Killed process 732 (fsck.ext2).
Out of Memory: Killed process 732 (fsck.ext2).

and this some pages

top gives me this info for fsck.ext2 :

  732 root       9   0  592M 465M  2068 S    64.7 92.6   6:31 fsck.ext2

Mem:   514360K av,  512176K used,    2184K free,       0K shrd,     564K
buff
Swap:  136544K av,  136544K used,       0K free                    3120K
cache

system has 512Megabyte memory (and 128mb swap (only fileserver, never
needed more swap)

I really wonder if there is something wrong with e2fsk ?
does it really need that much memory ?
(fsck on 2.2TB /dev/md0)

it was putting a lot of info on the screen (for some minutes) :
Duplicate/bad block in inode ... / ... ...  ... ... ...
(and scrolling in real fast speed)

e2fsprogs version 1.27 with kernel 2.4.20 (+lbd patch)
i tried upgrading e2fsutils to 1.32 (latest version), but this doesn't
help

any hints ? (maybe a way to disable the enormous output from
'Duplicate/bad block in inode ..' ?)

(also why does it tell, killed when it stays running (otherwise it can't
kill multiple times...))
