From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Several small raids or one big?
Date: Tue, 16 Jul 2002 02:55:53 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D3352F9.F01816EA@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any way to say which is "better"?  I'm trying to
set up our server here.  4 scsi disks of equal capacity,
should do raid5.  But the question is - how to set up
filesystems on them?  We'll need several addtitional
filesystems in additional to standard ones.  There are
2 options.

a) create set of partitions on each, one partition for
each /usr, /var, /home, etc., and create one raid device
for each filesystem.  I.e. sd[abcd]2 => md2 => /usr,
sd[abcd]5 => md3 => /var etc.

b) create one large partition, create raid array on it,
and use something like LVM to "partition" it.  Some essential
(system) partitions (/usr, /var) may be created on separate
raid arrays (as in option 2) in order to be less dependant on
LVM (I still can't trust it fully).

I know LVM's variant gives me more flexibility in layout, esp.
having in mind that we'll use Oracle on raw partitions heavily,
and that SCSI disks may have only 15 partitions max (this is
terrible small).

But the question is - will 2 raid arrais created on the same set
of disks work "better" than one, if accesses concurrently?  I.e.
having 2 concurrent processes that are both I/O bound but are
working with different filesystems, which layout of underliyin
devices is preferrable - 2 raid arrays or one large divided into
2 pieces somehow?  In principle, the end factor is disks anyway,
but will raid code block other process while servicing requests
from first process in this case too?  Disk drives can do TCQ and
can reorder/optimize requests somehow, I don't know if this helps
here or not.

May raid benefit from SMP machine in this context?  I think not,
since it should ensure consistency by doing some internal locking
anyway.  Well, for 2 arrays, 2 CPUs may be better than one (not
having in mind other processes), but one array seems to be for
one CPU anyway, correct? :)

And another question, probably an off-topic here, is - raid5 + lvm
combo - how it perform?  Is it worth it to try?  My tests shows
that LVM may significantly slow disk access down for raw devices,
and this is quite unacceptable for us.  But I can't imagine how it
will work once set up for real life load.  The problem is that it's
really difficult to set up a test machine: the whole process takes
several 10s of hours.  I've already set up multiple raid5 devices
as in variant a) above, it seems to work almost ok but system CPU
usage is relatively high.

Thank you.

/mjt
