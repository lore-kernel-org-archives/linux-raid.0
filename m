From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: RE: Incorrect array member slot assignment during assemble
Date: Tue, 22 Apr 2008 01:54:15 -0300
Message-ID: <18445.28535.783632.7696@fisica.ufpr.br>
References: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net>
	<18443.63473.834200.366911@fisica.ufpr.br>
	<20080421162014.at1xgstvtq8c048c@mail.jp-hosting.net>
	<18445.18648.388676.714441@fisica.ufpr.br>
	<A20315AE59B5C34585629E258D76A97C149DA6@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C149DA6@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe (david@santools.com) wrote on 21 April 2008 22:54:
 >No, just assemble with --force.
 >
 > >The other idea I have in mind is to - after a backup - recreate the  
 > >array using the initial configuration (raid-level 5, num-devices 3,  
 > >etc), and hope that the array can pick itself up again.
 > >
 > >Any thoughts much appreciated - thanks for helping out :)
 >
 >This is the last alternative, when you're sure the 2 disks are fine.
 >Then just re-create the array replacing the /dev/3rd-drive by the
 >word "missing". This won't change the data, it'll just re-write the
 >superblocks. Then do read-only fsck

 >=======
 >
 >I would go pick up a few extra  disks, boot to a CDROM
 >LINUX  image, and make raw block copies of the disks on the RAID and

Yes, that's what I said in the first msg.

 >then try to reconstruct with the copies of the data.

Of course, if the originals have problems reconstruction will probably
abort again...
