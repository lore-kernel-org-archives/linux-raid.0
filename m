From: maurice <mhilarius@gmail.com>
Subject: Re: Odd booting problem
Date: Wed, 12 Oct 2011 14:55:10 -0600
Message-ID: <4E95FEAE.1090809@gmail.com>
References: <4E8F8C63.1080600@gmail.com> <4E9316F8.7040800@gmail.com> <4E933557.1040909@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E933557.1040909@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: maurice <mhilarius@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Problem Solved!

Thanks VERY much to Michal Soltys who offered me lots of useful suggestions.

Also thanks to Jim Schatzman who chipped in with some good ideas as well.

In the end, while I tried those suggestions, it did not solve the problem.
I did a lot of reading and some experiments and here is what turned out 
to be the problem:

Dracut does the following:

+ [ -d /sysroot/proc ]
+ . /mount/99mount-root.sh
...
+ [ -n block:/dev/md1 -a -z  ]
+ mount -t auto -o ro /dev/md1 /sysroot
+ ROOTFS_MOUNTED=yes

So far so good.

BUT:  as I found, and for unclear reasons, there was no 'proc' on the 
file system present
on /dev/md1 (which was intended as our new /).

So dracut gets into a loop despite of ROOTFS_MOUNTED being already set:

+ [ -d /sysroot/proc ]
+ . /mount/99mount-root.sh
...
+ [ -n block:/dev/md1 -a -z  ]
+ mount -t auto -o ro /dev/md1 /sysroot
mount: /dev/md1 already mounted or /sysroot busy
mount: according to mtab, /dev/md1 is already mounted on /sysroot

That is absolutely true but not particularly illuminating.
Eventually this ends, quite late,

+ i=21
+ [ 21 -gt 20 ]
+ flock -s 9
+ emergency_shell Can't mount root filesystem

which is not particularly informative.

Bailing out quite a bit earlier, before everything scrolled off of the 
screen with something
like:
"Cannot find /proc on a canditate for a root filesystem; that cannot be 
right."
  would be quite a bit more helpful.

Alternatively if ROOTFS_MOUNTED is "yes" and that filesystem looks
like a reasonable candidate for /
(say 'etc/issue' and 'sbin' present)
Then why not offer to run 'mkdir -p /sysroot/{dev,proc,sys}'?
Do this after making sysroot writeable and then continue?

  That is possibly going too far but a notification with some useful 
information
  pointing to an error would be much better than "Can't mount".


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
