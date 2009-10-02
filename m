From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 09:31:07 -0700
Message-ID: <babafd2f0910020931i5b38316dpc6351d5d6ed5211@mail.gmail.com>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
	<887103.5263.qm@web38801.mail.mud.yahoo.com> <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
	<20091002151504.GA22207@cthulhu.home.robinhill.me.uk> <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
	<20091002155919.GB22207@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002155919.GB22207@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, robin@robinhill.me.uk
List-Id: linux-raid.ids

Hi,

On Fri, Oct 2, 2009 at 8:59 AM, Robin Hill <robin@robinhill.me.uk> wrot=
e:
> Either 0.90 or 1.0 will work (both are held at the end)- 0.90 allows =
for
> kernel auto-assembly, but is a legacy format. =A0Any modern Linux
> distribution will use an initrd which can assemble arrays with any
> superblock, so current advice would be to use 1.0.

Ok, that's clear.

> For a boot partition I'd stick with RAID-1, then use RAID-10,f2 for
> other partitions.

f2 is clear for read-mostly space, like most of /root.  But for /var?
/home? other /data?

I'm learning there a 'subtleties' to all this.

> There's no real advantage in using RAID-10,n4 over
> RAID-1 (it's a different code-path so there may be slight differences
> one way or the other, but nothing that will matter for a boot
> partition anyway), and just makes the setup more unusual.

I thought that RAID-10's disk failure survivability is n-2, for n >=3D4
drives.  RAID-1 over 4 drives can also survive 2-drive failure?

> It's up to you though - RAID-10,n4 and a four-way RAID-1 will have th=
e
> same on-disk layout, so either will work fine. =A0Oh - one other thin=
g is
> that RAID-1 is expandable (you can add other partitions later) wherea=
s
> RAID-10 is not currently.

Athough needing to expand /boot is hardly a requirement, I did NOT
realize that RAID-10 is not expandable.  Partitions ARE certainly
add-able within the LVM that spans the RAID-10, but I thoguth that
spindles, and new partition could be added after initial creation.
Need to read some more.

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
