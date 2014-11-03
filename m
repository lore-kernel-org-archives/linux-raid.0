From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Mon, 3 Nov 2014 19:04:08 +0100
Message-ID: <20141103180407.GA3076@lazy.lzy>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown>
 <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
 <20141103165217.3bfd3d3e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141103165217.3bfd3d3e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 03, 2014 at 04:52:17PM +1100, NeilBrown wrote:
[...]
> "simple matter of programming"
> Of course there would be a limit to how much data can be buffered in memory
> before it has to be flushed out.
> If you are mostly storing movies, then they are probably too large to
> buffer.  Why not just write them out straight away?

One scenario I can envision is the following.

You've a bunch of HDDs in RAID-5/6, which are
almost always in standby (spin down).
Together, you've 2 SSDs in RAID-10.

All the write (and read, if possible) operations
are done towards the SSDs.
When the SSD RAID is X% full, the RAID-5/6 is
activated and the data *moved* (maybe copied, with
proper cache policy) there.
In case of reading (a large file), the RAID-5/6 is
activated, the file copied to the SSD RAID, and,
when finished, the HDDs put in standby again.

Of course, this is *not* a block device protocol,
it is a filesystem one.
It is the FS that must handle the caching, because
only the FS can know the file size, for example.

bye,

-- 

piergiorgio
