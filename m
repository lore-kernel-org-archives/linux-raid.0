From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 21:57:40 +0100
Message-ID: <18905.6980.631038.776261@tree.ty.sabi.co.uk>
References: <c268e4660904050705v73f1aa0eud93357f1e369110c@mail.gmail.com>
	<20090405185421.RJPR28081.cdptpa-omta04.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405185421.RJPR28081.cdptpa-omta04.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> Several, actually.  Since the RAID array kept crashing,

Someone who talks or thinks in vague terms like "RAID array kept
crashing" is already on a bad path.

> I had to re-create it numerous times. I tried ext3 more than
> once, but the journal kept getting corrupted, and fixing it
> lost several files.

Well, 'ext3' is *exceptionally* well tested, and this points to
some problems with the storage system or the kernel or some
driver (e.g. use of some blob/binary proprietary driver in the
kernel). In theory everything should work with everything else
and everything should be bug free in every combination... In
practice wise people try not to beg for trouble.

> Once I lost several important files during a RAID expansion.
> In some cases I converted to ext2, and others I started out
> with ext2, but last I checked, one cannot grow an ext2 file
> system on the fly.

Modifying filesystem structure while the filesystem is operating
is a very good way to beg for trouble. Especially if under load.

That something is *possible* does not mean that it is wise to
rely on it.

[ ... ]

> Yes, but I had many problems with ext3, as well,


> and I definitely need a file system which can be grown on the
> fly.

Good luck with that. Perhaps you need to think again about your
requirements, and/or perhaps to get a much larger budget to do
some research and development into "dynamic storage pools".

Not many seem to have sorted out all subtle problems; I have
even heard rumours that even GPFS has issues in demanding
configurations.
