From: Chris Murphy <lists@colorremedies.com>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 21:53:29 -0600
Message-ID: <CAJCQCtRELEP8WxVpiS_E7i7raz+JbPOYTGvVvswCVHW__BC+nA@mail.gmail.com>
References: <20160321213829.GA16677@EIS>
	<trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
	<20160321230456.GA16913@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160321230456.GA16913@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Patrick Tschackert <Killing-Time@gmx.de>, Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 5:04 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:

> Of course you can also attempt to repair btrfs directly but
> if btrfs redundancy is not equal to RAID-6 then it won't be
> able to fix. (I think you already cleared that point on
> the btrfs mailing list and would not be asking here if
> btrfs had the magic ability to recover)

No such unicorns in Btrfs.

In the Btrfs thread, I suggested the md scrub "check", and when I saw
that high count I was like, no Patrick, do not change anything, don't
run any Btrfs repair tools, go talk to the linux-raid@ folks. Those
mismatches are not read errors. Those are discrepancies between data
and parity strips (chunks for md folks, I use SNIA strip terminology
because in Btrfs a chunk is a kind of super-extent or collection of
extents, either metadata or data).

Patrick, do you remember what your mkfs options were?

If default, it will be single profile for data chunks, and DUP for
metadata chunks. That means there's only one copy of data extents, and
two copies of metadata. The file system is the metadata including all
checksums for data and metadata, and all trees. The problem though is
there's a possible single source of failure in really narrow cases.
Everything in Btrfs land is a logical address. if you do filefrag on a
file, the physical address * 4096 is the logical address within
Btrfs's address space, it's not a physical block. That address has to
be referenced in the chunk tree, which is what references two things:
what device(s) *and* what sector on those devices. So even though
there's a duplicate of the chunk tree, since there's only one logical
address in the super for the chunk tree, if that logical address
doesn't resolve to a sane physical location, there's no way to find
out where any copies are. So it's stuck.


Per the Btrfs FAQ:
------
There are three superblocks: the first one is located at 64K, the
second one at 64M, the third one at 256GB. The following lines reset
the magic string on all the three superblocks

# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((64*1024+64))
# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((64*1024*1024+64))
# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((256*1024*1024*1024+64))
------

So if someone can do the math and figure out what physical devices
those supers might be on, with a 64K chunk and 9 devices, might be
funny if they end up all on one drive... tragically funny. Hopefully
they're on multiple drives thought, and this suggests at least the
critical minimum number of drives are still sane and this can be
recovered even minus two drives.

If there's more than two drives toasted, then I don't think Btrfs can
help at all - same as any other file system.


-- 
Chris Murphy
