From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 14 Mar 2005 12:24:03 +0100
Message-ID: <20050314112403.GT3858@marowsky-bree.de>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <16949.26113.68948.938529@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-14T21:22:57, Neil Brown <neilb@cse.unsw.edu.au> wrote:

> > Hi there, just a question about how the bitmap stuff works with
> > 1++-redundancy, say RAID1 with 2 mirrors, or RAID6.
> I assume you mean RAID1 with 3 drives (there isn't really one main
> drive and all the others are mirrors - all drives are nearly equal).

Yeah, that's what I meant.

(BTW, if they are all equal, how to you figure out where to sync from?
Isn't the "first" one also the first one to receive the writes, so
unless it's somehow identified as bad, it's the one which will have the
"best" data?)

> We haven't put any significant work into bitmap intent logging for
> levels other than raid1, so some of the answer may be pure theory.

OK.

(Though in particular for raid5 with the expensive parity and raid6 wit=
h
the even more expensive parity this seems desireable.)

> > One disk fails and is replaced/reattached, and resync begins. Now
> > another disk fails and is replaced. Is the bitmap local to each
> > disk?
> Bitmap is for the whole array, not per-disk.
> If there are any failed drives, bits are not cleared from the bitmap.
> If a drive fails then any active resync is aborted and restarted
> (possibly this is not optimal...).
>
> If a failed disk is re-attached, then only the blocks changed since
> that the array was known-good are resynced.  If a new drive is added,=
 all
> blocks are synced.

I think each disk needs to have it's own bitmap in the long run. On
start, we need to merge them.

I'm thinking about network replication here, where it needs to be
figured out which mirror has the 'good' data, but with a little bit of
construction, the problem also arises for a single node:

Consider that we crash and come back with just one side of the mirror,
and then we crash again and come back with the other side. When both ar=
e
restored, the bitmaps need to be merged so that we can create one
coherent image from either/or. Admittedly, for a single node, this is
=2E.. uhm, well, pretty much constructed and a good time to get out the
backup tapes ;-)

> > And in case of RAID1, with 4 disks (and two of them resyncing), cou=
ld
> > disk3 be rebuild from disk1 and disk4 from disk2 (as to optimize di=
sk
> > bandwidth)?
> If two are resyncing, they will resync in step with each other so
> there is no point in reading from disk2 as well as disk1.  Just read
> from disk 1 and write to disks 3 and 4.

Yes, I guess that makes perfect sense with a global bitmap.

> Does that answer your questions?

Yes, it helps me to better understand where we are right now...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
