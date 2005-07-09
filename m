From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 assembly requires manual "mdadm --run"
Date: Sat, 9 Jul 2005 11:44:28 +1000
Message-ID: <17103.11260.748962.629919@cse.unsw.edu.au>
References: <200506261621.01799.mlaks@verizon.net>
	<62b0912f05070623185b90e732@mail.gmail.com>
	<17102.26306.174427.502866@cse.unsw.edu.au>
	<62b0912f05070811386bf7c72d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Friday July 8
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 8, molle.bestefich@gmail.com wrote:
> 
> So a clean RAID1 with a disk missing should start without --run, just
> like a clean RAID5 with a disk missing?

Anything degraded needs at least --run or --scan.

> 
> Nevermind, I'll try to reproduce it instead of asking too many questions.
> And I suck a bit at testing MD with loop devices, so if someone could
> pitch in and tell me what I'm doing wrong here, I'd appreciate it very
> much (-:
> 
> # mknod /dev/md0 b 9 0
> # dd if=/dev/zero of=test1 bs=1M count=100
> # dd if=/dev/zero of=test2 bs=1M count=100
> # dd if=/dev/zero of=test3 bs=1M count=100
> # losetup /dev/loop1 test1
> # losetup /dev/loop2 test2
> # losetup /dev/loop3 test3
> # mdadm --create /dev/md0 -l 1 -n 3 /dev/loop1 /dev/loop2 /dev/loop3
> mdadm: array /dev/md0 started.
> 
> # mdadm --detail --scan > /etc/mdadm.conf
> # cat /etc/mdadm.conf
> ARRAY /dev/md0 level=raid1 num-devices=3
>    UUID=1dcc972f:0b856580:05c66483:e14940d8
>    devices=/dev/loop/1,/dev/loop/2,/dev/loop/3

/dev/loop/N is reported instead of /dev/loopN because mdadm only has
major/minor device numbers to go on and scans /dev, returning the
first name it finds. 1.12.0 returns the shortest name it finds.


> 
> # mdadm --stop /dev/md0
> # mdadm --assemble --scan
> mdadm: no devices found for /dev/md0
> 
> // ^^^^^^^^^^^^^^^^^^^^^^^^  ??? Why?

The ARRAY line doesn't tell mdadm where to find the array.  It only
tells mdadm how to recognised the components when they are found(*).
The DEVICES line (which you don't have) tells mdadm where to find
components.
So:
  echo 'DEVICES /dev/loop?' > /etc/mdadm.conf
  mdadm --detail --scan >> /etc/mdadm.conf
  mdadm --stop /dev/md0
  mdadm --assemble --scan
should work

> 
> # mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
> mdadm: /dev/md0 has been started with 3 drives.
> 
> // So far so good..
> 
> # mdadm --stop /dev/md0
> # losetup -d /dev/loop3
> # mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
> mdadm: no RAID superblock on /dev/loop7
> mdadm: /dev/loop7 has no superblock - assembly aborted
> 
> // ^^^^^^^^^^^^^^^^^^^^^^^^  ??? It aborts :-(...
> // Doesn't an inactive loop device seem the same as a missing disk
> to MD?

I assume that is loop3, not loop7 ??

You have asked mdadm to assemble /dev/loop1 /dev/loop2 and /dev/loop3
into an array.  But it can tell that they are not all parts of the
same array (infact loop3 isn't part of an array at all).
The only parts of the array that you currently have are on /dev/loop1
and /dev/loop2. So you want to

  mdadm --assemble /dev/md0 --run /dev/loop1 /dev/loop2
(you need --run to convince mdadm that you know what you are doing).
Not that with /dev/loop3 no funcitoning,
  mdadm --assemble --scan
will still work.

NeilBrown


(*)
The mdadm.conf entry
> ARRAY /dev/md0 level=raid1 num-devices=3
>    UUID=1dcc972f:0b856580:05c66483:e14940d8
>    devices=/dev/loop/1,/dev/loop/2,/dev/loop/3

tells mdadm:
  You can recognise components of /dev/md0 as they have a raid
  superblock which records the level as 'raid1', the number of devices
  as '3', the UUID as 1dcc972f:0b856580:05c66483:e14940d8, and they
  will only be on one of the devices /dev/loop/1, /dev/loop/2, or
  /dev/loop/3.

Normally you will not want the 'devices=' section and mdadm 1.12.0
won't report if unless you give a '-v'.

NeilBrown
