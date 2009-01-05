From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 04 Jan 2009 21:43:38 -0500
Message-ID: <yq14p0e4gmd.fsf@sermon.lab.mkp.net>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	<49580061.9060506@yahoo.com>
	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	<yq13ag174af.fsf@sermon.lab.mkp.net>
	<495F6622.9010103@anonymous.org.uk>
	<yq1eizj5xos.fsf@sermon.lab.mkp.net>
	<4960AC15.8030207@anonymous.org.uk>
	<4960BE63.3040608@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4960BE63.3040608@anonymous.org.uk> (John Robinson's message of "Sun\, 04 Jan 2009 13\:49\:23 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:

John> I've thought about this again, and I'm wrong; there may be
John> complications in handling the cookies up and down the stack where
John> more than one layer thinks it knows how to have another go, but I
John> can see what you describe as being useful and relatively
John> device-agnostic.

Yeah, care will need to be taken if you have multiple layers in the
stack providing redundancy.  That's usually not the case, though.


John> I wonder if there might also be scope for cookies going down
John> through the stack to carry an indication of how hard to try; some
John> filesystems or other consumers of block devices may be willing to
John> ask again or want to be told about problems quickly (e.g. btrfs
John> over RAID over TLER-equipped discs), while some may need best
John> efforts all out first time because they can't cope will failure
John> returns (e.g. FAT over cheap IDE discs).

We already have this functionality.  It's orthogonal to the integrity
bits.  You can tell the low-level drivers either fail a request
immediately or to retry.

That's only a software thing, though.  It doesn't work terribly well
with consumer harddrives that assume there's only one copy of the data
and consequently enter annoying-click-mode and retry for a long time.
Nearline and enterprise drives assume there's a redundant copy and will
not try as hard under the assumption that you know how to remedy the
problem.

-- 
Martin K. Petersen	Oracle Linux Engineering
