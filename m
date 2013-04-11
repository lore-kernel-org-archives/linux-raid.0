From: Phil Turmel <philip@turmel.org>
Subject: Re: Odd --examine output
Date: Thu, 11 Apr 2013 17:15:37 -0400
Message-ID: <516727F9.9020008@turmel.org>
References: <CD8C946E.4111D%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD8C946E.4111D%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/2013 04:31 PM, Vanhorn, Mike wrote:

> So, if I created the array using version 1.2 of the metadata and the
> devices specified are sd[cdefghij]1, then why am I not able to see that
> metadata now?
> 
> I am really confused.

Version 0.90 metadata, which lives at the end of the disk or partition,
doesn't include a length or other piece of partition geometry that
clearly identifies the beginning of the array.  So v0.90 metadata that
belongs to the last partition of a disk can be mistaken for metadata
belonging to that whole disk, and vice versa.

v1.x metadata has more device info, so this can't happen to v1.0
metadata, even though it is at the end of the device as well.  v1.1 and
v1.2 metadata are at the beginning, therefore won't be found with the
wrong starting sector.

I suspect what happened to your system:

1) Old array running w/ v0.90 metadata on /dev/sd[]1 is taken out of
service.
2) New array w/ v1.2 metdata is created, but for some reason, the v0.90
metadata doesn't get destroyed.
3) Partition tables on certain disks are wiped, hiding the v1.2 metadata.

I'm not sure if any particular version of mdadm would do #2, but it is
plausible.

#3 is quite concerning, as it suggest the presence of a rogue program
with admin rights, or a rogue administrator, or a *really* questionable
device driver.

Anyways, if you copy the partition table from a properly working drive
to one of the oddballs, it might expose the original partition data,
including the v1.2 metadata.  (Although, you seem to have partitions
starting at sector 63--a real performance killer for modern drives.)

There's other data I suggested you collect in my response to your
original inquiry.  There'd be much less guesswork in my replies if you
supplied it.

Phil
