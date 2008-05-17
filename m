From: "David Lethe" <david@santools.com>
Subject: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
Date: Sat, 17 May 2008 14:10:00 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <482EF6A7.2020909@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to figure out a mechanism to safely repair a stripe of data
when I know a particular disk has a unrecoverable read error at a
certain physical block (for 2.6 kernels) 

My original plan was to figure out the range of blocks in md device that
utilizes the known bad block and force a raw read on physical device
that covers the entire chunk and let the md driver do all of the work.  

Well, this didn't pan out. Problems include issues where if bad block
maps to the parity block in a stripe then md won't necessarily
read/verify parity, and in cases where you are running RAID1, then load
balancing might result in the kernel reading the bad block from the good
disk.

So the degree of difficulty is much higher than I expected.  I prefer
not to patch kernels due to maintenance issues as well as desire for the
technique to work across numerous kernels and  patch revisions, and
frankly, the odds are I would screw it up.  An application-level program
that can be invoked as necessary would be ideal.

As such, anybody up to the challenge of writing the code?  I want it
enough to paypal somebody $500 who can write it, and will gladly open
source the solution.  

(And to clarify why, I know physical block x on disk y is bad before the
O/S reads the block, and just want to rebuild the stripe, not the entire
md device when this happens. I must not compromise any file system data,
cached or non-cached that is built on the md device.  I have system with
>100TB and if I did a rebuild every time I discovered a bad block
somewhere, then a full parity repair would never complete before another
physical bad block is discovered.)

Contact me offline for the financial details, but I would certainly
appreciate some thread discussion on an appropriate architecture.  At
least it is my opinion that such capability should eventually be native
Linux, but as long as there is a program that can be run on demand that
doesn't require rebuilding or patching kernels then that is all I need.

David @ santools.com


 

