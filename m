From: Arthur Jones <ajones@riverbed.com>
Subject: Re: raid10 failing to fail...
Date: Tue, 22 Jul 2008 14:07:13 -0700
Message-ID: <20080722210713.GB18246@ajones-laptop.nbttech.com>
References: <20080721190018.GA18246@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080721190018.GA18246@ajones-laptop.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all, ...

On Mon, Jul 21, 2008 at 12:00:18PM -0700, Arthur Jones wrote:
> Hi All,  I have a raid10 array md0 which, when I
> fail all reads on the first underlying block device
> (/dev/sda5), reads from the array hang forever.
> 
> This is easy for me to reproduce (blkflsbuf is
> a simple C program that does a BLKFLSBUF ioctl):
> 
> # mount -t debugfs debugfs /debug
> # echo 1 > /debug/fail_make_request/interval
> # echo 100 > /debug/fail_make_request/probability
> # echo 0 > /debug/fail_make_request/space
> # echo N > /debug/fail_make_request/task-filter
> # echo -1 > /debug/fail_make_request/times
> # echo 2 > /debug/fail_make_request/verbose
> # ./blkflsbuf /dev/md0
> # ./blkflsbuf /dev/sda5
> # echo 1 > /sys/block/sda/sda5/make-it-fail
> # dd if=/dev/sda5 of=/dev/null count=1
> [fails as expected]
> # ./blkflsbuf /dev/sda5
> # dd if=/dev/md0 of=/dev/null count=1
> [hangs here -- kill -INT, -TERM, -KILL
>  have no effect...]
> 
> I expected to get the reads coming from the
> working mirror and to have the failing disk
> marked Faulty.  This is tested w/ today's
> git tree, but seems to happen on every kernel
> I've tried (2.6.9 RHEL4, 2.6.26).
> 
> Any ideas?  Thanks...

It seems to be stuck at wait_event_lock_irq in freeze_array()
in raid10.c.  Maybe this is similar to:

http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/0401.html

Arthur
