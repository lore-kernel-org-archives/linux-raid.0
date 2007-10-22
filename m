From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: slow raid5 performance
Date: Mon, 22 Oct 2007 21:52:10 +0100
Message-ID: <18205.3450.273992.663407@base.ty.sabi.co.UK>
References: <780710.47922.qm@web52802.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <780710.47922.qm@web52802.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Mon, 22 Oct 2007 10:18:59 -0700 (PDT), Peter
>>> <thenephilim13@yahoo.com> said:

[ ... ]

thenephilim13> I can understand that if a RMW happens it will
thenephilim13> effectively lower the write throughput
thenephilim13> substantially but I'm not sure entirely sure why
thenephilim13> this would happen while writing new content,

It does not really depend on new vs. old content, but on whether
the filesystem knows the real address of the blocks it is
writing to and assembles writes in sequences beginning at the
appropriate boundary and of the approriate length. XFS (at least
some recetn versions) makes a valiant attempt to deduce the
right values from the underlying storage system, but double
checking usually helps.

>> [ ... ] My impression is that something that takes less than
>> 5% on a developers's system does not get looked at, even if
>> it takes 50% on your system. The Linux kernel was very
>> efficient when most developers were using old cheap PCs
>> themselves. "scratch your itch" rules.

thenephilim13> This is a rather unfortunate situation, it seems
thenephilim13> that some of the roots are forgotten,

If somebody's roots are to be a poor postdoc/postgrad scrounging
used/broken PC parts and then they get hired with a huge salary
and given a 4-CPU 4GB PC to play with, usually they are very
happy to forget those roots and don't think it unfortunate.

Just another instance also of the "who pays the piper calls the
tunes" principle.

thenephilim13> especially in a case like this where one would
thenephilim13> think running a file server on a modest CPU
thenephilim13> should be enough.

Let's say that I have been myself been astonished by how CPU
intensive is the Linux page cache. But then I think that quite a
few aspects of the Linux page/IO management subsystems (never
mind sick, mad horrors like 'vm/page-cluster') could be
substantially improved by someone who had read the relevant
literature (I am not volunteering unfortunately) instead of
trying to wing it and flounder.

[ ... ]

>> Misaligned writes and page cache CPU time most likely.

thenephilim13> What influence would adding more harddrives to
thenephilim13> this RAID have?

If you can guarantee that writes (and reads, less importantly)
be aligned and of the right size adding more drives improves
performance as long as this does not hit the bus bandwidth
limits and the CPU ones (and your system likely is near those);
unfortunately adding more drives makes it less likely that
writes will be properly aligned and of the right size, never
mind all the other downsides. A 3-drive RAID5 is one of only two
common (or uncommon) cases in which RAID5 is a tolerable idea.

thenephilim13> I know in terms of a Netapp filer they always
thenephilim13> talk about spindle count for performance.

NetApp use something very different from RAID5 (and which is not
quite RAID4)and they also have a custom filesystem described in
an interesting paper:

  http://www.netapp.com/library/tr/3002.pdf
  http://blogs.sun.com/val/entry/zfs_faqs_freenix_cfp_new
