From: maarten <maarten@ultratux.net>
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 22:47:47 +0100
Message-ID: <200501192247.47026.maarten@ultratux.net>
References: <20050117010355.GH347@unthought.net> <200501192217.29258.maarten@ultratux.net> <bqv2c2-uec.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bqv2c2-uec.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 19 January 2005 22:24, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > On Wednesday 19 January 2005 21:19, Peter T. Breuer wrote:
> > > Poonam Dalya <poonamsbox@yahoo.com> wrote:

> > Sigh.
>
> You don't understand - he mounted the raw partitions that make up the
> raid array WHILE THE RAID WAS RUNNING somewhere else.

In that case, okay.

> If the mount had failed he would have said. Therefore it did not fail.
> If he had unmounted the raid array first, then the umount would have
> flushed buffers to that device (the kernel sends flush_buffers or
> whatever it is called nowadays) and the file would have been visible
> when he did the later mount.

I tried to reproduce it, and it is even more serious than that, upon first 
glance.  So you're right.  Witness below:

dozer:~ # df
/dev/md0               1953344   1758636    194708  91% /

dozer:~ # cat /proc/mdstat
md0 : active raid1 hde1[1]
      1953408 blocks [3/1] [_U_]

dozer:~ # mount -o ro /dev/hde1 /mnt/
dozer:~ # df
/dev/md0               1953344   1758640    194704  91% /
/dev/hde1              1953344   1758636    194708  91% /mnt

dozer:~ # touch /foobar

dozer:~ # ls -l /mnt/foobar
/bin/ls: /mnt/foobar: No such file or directory

dozer:~ # sync

dozer:~ # ls -l /mnt/foobar
/bin/ls: /mnt/foobar: No such file or directory

dozer:~ # umount /mnt/
dozer:~ # mount -o ro /dev/hde1 /mnt/
dozer:~ # ls -l /mnt/foobar
/bin/ls: /mnt/foobar: No such file or directory

dozer:~ # ls -l /foobar
-rw-r--r--    1 root     root            0 Jan 19 22:33 /foobar

Strange, eh ? (obviously I can't umount /dev/md0 to see...)

Maarten

-- 

