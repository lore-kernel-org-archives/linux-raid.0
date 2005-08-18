From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Thu, 18 Aug 2005 12:24:58 +0200
Message-ID: <20050818102458.GJ13344@marowsky-bree.de>
References: <1124322731.3810.77.camel@localhost.localdomain> <17156.7305.638579.812295@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17156.7305.638579.812295@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-08-18T15:28:41, Neil Brown <neilb@cse.unsw.edu.au> wrote:

> If we want to mirror a single drive in a raid5 array, I would really
> like to do that using the raid1 personality.
> e.g.
>    suspend io
>    remove the drive
>    build a raid1 (with no superblock) using the drive.
>    add that back into the array
>    resume io.

I hate to say this, but this is something where the Device Mapper
framework, with it's suspend/resume options and the ability to change
the mapping atomically.

Maybe copying some of the ideas would be useful.

=46reeze, reconfigure one disk to be RAID1, resume - all IO goes on whi=
le
at the same time said RAID1 re-mirrors to the new disk. Repeat with a
removal later.

> To handle read failures, I would like the first step to be to re-writ=
e
> the failed block.  I believe most (all?) drives will relocate the
> block if a write cannot succeed at the normal location, so this will
> often fix the problem. =20

Yes. This would be highly useful.

> A userspace process can then notice an unacceptable failure rate and
> start a miror/swap process as above.

Agreed. Combined with SMART monitoring, this could provide highly usefu=
l
features.

> This possible doesn't handle the possibility of a write failing very
> well, but I'm not sure what your approach does in that case.  Could
> you explain that?

I think a failed write can't really be handled - it might be retried
once or twice, but then the way to proceed is to kick the drive and
rebuild the array.

> It also means that if the raid1 rebuild hits a read-error it cannot
> cope whereas your code would just reconstruct the block from the rest
> of the raid5.

Good point. One way to fix this would be to have a callback to one leve=
l
up "Hi, I can't read this section, can you reconstruct and give it to
me?". (Which is a pretty ugly hack.)

However, that would also assume that the data on the disk which _can_ b=
e
read still can be trusted. I'm not sure I'd buy that myself, untrusted.
But a periodic background consistency check for RAID might help convinc=
e
users that this is indeed the case ;-)

If you can no longer pro-actively reconstruct the disk because it has
indeed failed, maybe treating it like a failed disk and rebuilding the
array in the "classic" fashion isn't the worst idea, though.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
