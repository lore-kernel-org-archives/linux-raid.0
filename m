From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Wed, 27 Jul 2016 13:55:49 +0100
Message-ID: <22424.44885.515889.315155@tree.ty.sabi.co.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
	<22423.44287.974770.114127@tree.ty.sabi.co.uk>
	<5797C5CE.6020300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797C5CE.6020300@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> In general an in-place migration is a very dangerous operation
>> because it stresses existing hardware a lot plus it uses code
>> that is rarely used and is quite complex.

> But copying everything off will stress it just as much,
> surely? The alternatives imho are worse ...

* The very different access patterns of a block-by-block copy to
  new fresh disks and the migration-in-place having to rewrite by
  moving around the contents of all involved disks.

* That in a copy there is always the original to fall back on, a
  migration-in-place that fails can be fatal.

I am giving for granted here that one way or another at least one
copy of all the data has to be done; and block-by-block device
sequential copy is probably the best, followed by file-by-file
sequential copy, followed by in-place migration.

Note: RAID5 in-place migration does not mean that existing blocks
stay where they are, it means that (nearly) all blocks get moved,
but inside the existing device set.

So probably the best combination here, because the O.P. does not
currently have any redundancy, is to first ensure there is some
kind of copy of the data and/or redundancy, on the way to getting
a new storage layout. Because *any* whole-content data operation
stresses the storage system.
