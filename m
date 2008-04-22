From: "David Lethe" <david@santools.com>
Subject: RE: Incorrect array member slot assignment during assemble
Date: Mon, 21 Apr 2008 22:54:20 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C149DA6@34093-C3-EVS3.exchange.rackspace.com>
References: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net><18443.63473.834200.366911@fisica.ufpr.br><20080421162014.at1xgstvtq8c048c@mail.jp-hosting.net> <18445.18648.388676.714441@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <18445.18648.388676.714441@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>, jay@bernard.vm.bytemark.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, just assemble with --force.

 >The other idea I have in mind is to - after a backup - recreate the  
 >array using the initial configuration (raid-level 5, num-devices 3,  
 >etc), and hope that the array can pick itself up again.
 >
 >Any thoughts much appreciated - thanks for helping out :)

This is the last alternative, when you're sure the 2 disks are fine.
Then just re-create the array replacing the /dev/3rd-drive by the
word "missing". This won't change the data, it'll just re-write the
superblocks. Then do read-only fsck
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


=======

If the data is really important, and worth a few thousand dollars or
more, then try calling a company that specializes in data recovery.  If
it was me, then I would go pick up a few extra  disks, boot to a CDROM
LINUX  image, and make raw block copies of the disks on the RAID and
then try to reconstruct with the copies of the data.  No going back if
the recovery software doesn't work.




