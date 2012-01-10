From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Mon, 09 Jan 2012 21:54:56 -0600
Message-ID: <4F0BB690.4040904@hardwarefreak.com>
References: <20111212115459.GC20730@fi.muni.cz> <4EE61EAE.20101@anonymous.org.uk> <20120106150823.GX25976@fi.muni.cz> <20231.9177.523012.471046@tree.ty.sabi.co.UK> <20120106201150.GB13358@fi.muni.cz> <4F077BE1.4050408@hardwarefreak.com> <20232.21966.952905.343604@tree.ty.sabi.co.UK> <4F087211.5020000@hardwarefreak.com> <20234.61352.443686.100881@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20234.61352.443686.100881@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/9/2012 7:46 AM, Peter Grandi wrote:

> Those able to do a web search with the relevant keywords and
> read documentation can find some mentions of single SSD RMW and
> address/length alignment, for example here:
> 
>   http://research.cs.wisc.edu/adsl/Publications/ssd-usenix08.pdf
>   http://research.microsoft.com/en-us/projects/flashlight/winhec08-ssd.pptx
>   http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-09-2.pdf
> 
> Mentioned in passing as something pretty obvious, and there are
> other similar mentions that come up in web searches because it
> is a pretty natural application of thinking about RMW issues.

Yes, I've read such things.  I was eluding to the fact that there are at
least a half dozen different erase block sizes and algorithms in use by
different SSD manufacturers.  There is no standard.  And not all of them
are published.  There is no reliable way to do such optimization
generically.

> Now I eagerly await your explanation of the amazing "Hoeppner
> effect" by which address/length aligned writes on RAID0/1/10
> have significant benefits and of the audacious "Hoeppner
> principle" by which 'concat' is as good as RAID0 over the same
> disks.

IIRC from a previous discussion I had with Neil Brown on this list,
mdraid0, as with all the striped array code, runs as a single kernel
thread, limiting its performance to that of a single CPU.  A linear
concatenation does not run as a single kernel thread, but is simply an
offset calculation routine that, IIRC, executes on the same CPU as the
caller.  Thus one can theoretically achieve near 100% CPU scalability
when using concat instead of mdraid0.  So the issue isn't partial stripe
writes at the media level, but the CPU overhead caused by millions of
the little bastards with heavy random IOPS workloads, along with
increased numbers of smaller IOs through the SCSI/SATA interface,
causing more interrupts thus more CPU time, etc.

I've not run into this single stripe thread limitation myself, but have
read multiple cases where OPs can't get maximum performance from their
storage hardware because their top level mdraid stripe thread is peaking
a single CPU in their X-way system.  Moving from RAID10 to a linear
concat gets around this limitation for small file random IOPS workloads.
 Only when using XFS and a proper AG configuration, obviously.  This is
my recollection of Neil's description of the code behavior.  I could
very well have misunderstood, and I'm sure he'll correct me if that's
the case, or you, or both. ;)

Dave Chinner had some input WRT XFS on concat for this type of workload,
stating it's a little better than RAID10 (ambiguous as to hard/soft).
Did you read that thread Peter?  I know you're on the XFS list as well.
 I can't exactly recall at this time Dave's specific reasoning, I'll try
to dig it up.  I'm thinking it had to do with the different distribution
of metadata IOs between the two AG layouts, and the amount of total head
seeking required for the workload being somewhat higher for RAID10 than
for the concat of RAID1 pairs.  Again, I could be wrong on that, but it
seems familiar.  That discussion was many months ago.

-- 
Stan
