From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 04 Jan 2009 02:37:23 -0500
Message-ID: <yq1eizj5xos.fsf@sermon.lab.mkp.net>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	<49580061.9060506@yahoo.com>
	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	<yq13ag174af.fsf@sermon.lab.mkp.net>
	<495F6622.9010103@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <495F6622.9010103@anonymous.org.uk> (John Robinson's message of "Sat\, 03 Jan 2009 13\:20\:34 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:

John> Excuse me if I'm being dense - and indeed tell me! - but RAID
John> 4/5/6 already suffer from having to do ready-modify-write for
John> small writes, so is there any chance this could be done at
John> relatively little additional expense for these?

You'd still need to store a checksum somewhere else, incurring
additional seek cost.  You could attempt to weasel out of that by adding
the checksum sector after a limited number of blocks and hope that you'd
be able to pull it in or write it out in one sweep.

The downside is that assume we do checksums on - say - 8KB chunks in the
RAID5 case.  We only need to store a few handfuls of bytes of checksum
goo per block.  But we can't address less than a 512 byte sector.  So we
need to either waste the bulk of 1 sector for every 16 to increase the
likelihood of adjacent access.  Or we can push the checksum sector
further out to fill it completely.  That wastes less space but has a
higher chance of causing an extra seek.  Pick your poison.

The reason I'm advocating checksumming on logical (filesystem) blocks is
that the filesystems have a much better idea what's good and what's bad
in a recovery situation.  And the filesystems already have an
infrastructure for storing metadata like checksums.  The cost of
accessing that metadata is inherent and inevitable.

btrfs had checksums from the get-go.  The XFS folks are working hard on
adding them.  ext4 is going to checksum metadata, I believe.  So this is
stuff that's already in the pipeline.

We also don't want to do checksumming at every layer.  That's going to
suck from a performance perspective.  It's better to do checksumming
high up in the stack and only do it once.  As long as we give the upper
layers the option of re-driving the I/O.

That involves adding a cookie to each bio that gets filled out by DM/MD
on completion.  If the filesystem checksum fails we can resubmit the I/O
and pass along the cookie indicating that we want a different copy than
the one the cookie represents.

-- 
Martin K. Petersen	Oracle Linux Engineering
