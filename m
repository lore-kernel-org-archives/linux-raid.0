From: Shaohua Li <shli@kernel.org>
Subject: Re: raid0 vs. mkfs
Date: Sun, 27 Nov 2016 22:08:28 -0800
Message-ID: <20161128060828.vxhe4fq74gohoidd@kernel.org>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oa108a1x.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Avi Kivity <avi@scylladb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 04:09:46PM +1100, Neil Brown wrote:
> On Mon, Nov 28 2016, Avi Kivity wrote:
> 
> > mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large 
> > disk that supports TRIM/DISCARD (erase whichever is inappropriate).  
> > That is because mkfs issues a TRIM/DISCARD (erase whichever is 
> > inappropriate) for the entire partition. As far as I can tell, md 
> > converts the large TRIM/DISCARD (erase whichever is inappropriate) into 
> > a large number of TRIM/DISCARD (erase whichever is inappropriate) 
> > requests, one per chunk-size worth of disk, and issues them to the RAID 
> > components individually.
> >
> >
> > It seems to me that md can convert the large TRIM/DISCARD (erase 
> > whichever is inappropriate) request it gets into one TRIM/DISCARD (erase 
> > whichever is inappropriate) per RAID component, converting an O(disk 
> > size / chunk size) operation into an O(number of RAID components) 
> > operation, which is much faster.
> >
> >
> > I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with 
> > the operation taking about a quarter of an hour, continuously pushing 
> > half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests 
> > to the disk. Linux 4.1.12.
> 
> Surely it is the task of the underlying driver, or the queuing
> infrastructure, to merge small requests into large requests.
> Why should this have anything do to with RAID0?

That's what I'm wondering too. The block layer should merge the small requests
into larget one, and it does, IIRC. There is one bug related to this (commit
9c573de3283af007e), but it only applies to 4.3+.

Thanks,
Shaohua
