From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mismatch_cnt questions
Date: Thu, 08 Mar 2007 08:54:10 -0500
Message-ID: <yq1tzwvj0xp.fsf@sermon.lab.mkp.net>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	<17898.45673.573800.56474@notabene.brown>
	<45EB3867.8050907@eyal.emu.id.au>
	<17899.18568.523543.478792@notabene.brown>
	<45EBCA83.40106@eyal.emu.id.au>
	<17900.43653.510415.553440@notabene.brown>
	<45EFAFB8.3070703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EFAFB8.3070703@zytor.com> (H. Peter Anvin's message of "Wed, 07 Mar 2007 22:39:52 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

>> What we really want in drives that store 520 byte sectors so that a
>> checksum can be passed all the way up and down through the stack
>> .... or something like that.
>> 

hpa> A lot of SCSI disks have that option, but I believe it's not
hpa> arbitrary bytes.  In particular, the integrity check portion is
hpa> only 2 bytes, 16 bits.

It's important to distinguish between drives that support 520 byte
sectors and drives that include the Data Integrity Feature which also
uses 520 byte sectors.

Most regular SCSI drives can be formatted with 520 byte sectors and a
lot of disk arrays use the extra space to store an internal checksum.
The downside to 520 byte sectors is that it makes buffer management a
pain as 512 bytes of data is followed by 8 bytes of protection data.
That sucks when writing - say - a 4KB block because your scatterlist
becomes long and twisted having to interleave data and protection
data every sector.

The data integrity feature also uses 520 byte byte sectors.  The
difference is that the format of the 8 bytes is well defined.  And
that both initiator and target are capable of verifying the integrity
of an I/O.  It is correct that the CRC is only 16 bits.

DIF is strictly between HBA and disk.  I'm lobbying HBA vendors to
expose it to the OS so we can use it.  I'm also lobbying to get them
to allow us to submit the data and the protection data in separate
scatterlists so we don't have to do the interleaving at the OS level.


hpa> One option, of course, would be to store, say, 16
hpa> sectors/pages/blocks in 17 physical sectors/pages/blocks, where
hpa> the last one is a packing of some sort of high-powered integrity
hpa> checks, e.g. SHA-256, or even an ECC block.  This would hurt
hpa> performance substantially, but it would be highly useful for very
hpa> high data integrity applications.

A while ago I tinkered with something like that.  I actually cheated
and stored the checking data in a different partition on the same
drive.  It was a pretty simple test using my DIF code (i.e. 8 bytes
per sector).

I wanted to see how badly the extra seeks would affect us.  The
results weren't too discouraging but I decided I liked the ZFS
approach better (having the checksum in the fs parent block which
you'll be reading anyway).

-- 
Martin K. Petersen	Oracle Linux Engineering

