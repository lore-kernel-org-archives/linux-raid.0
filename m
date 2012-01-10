From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Tue, 10 Jan 2012 10:25:20 -0600
Message-ID: <4F0C6670.9040508@hardwarefreak.com>
References: <20111212115459.GC20730@fi.muni.cz> <4EE61EAE.20101@anonymous.org.uk> <20120106150823.GX25976@fi.muni.cz> <20231.9177.523012.471046@tree.ty.sabi.co.UK> <20120106201150.GB13358@fi.muni.cz> <4F077BE1.4050408@hardwarefreak.com> <20232.21966.952905.343604@tree.ty.sabi.co.UK> <4F087211.5020000@hardwarefreak.com> <20234.61352.443686.100881@tree.ty.sabi.co.UK> <4F0BB690.4040904@hardwarefreak.com> <20120110151336.568f5da4@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120110151336.568f5da4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/9/2012 10:13 PM, NeilBrown wrote:

>> IIRC from a previous discussion I had with Neil Brown on this list,
>> mdraid0, as with all the striped array code, runs as a single kernel
>> thread, limiting its performance to that of a single CPU.  A linear
>> concatenation does not run as a single kernel thread, but is simply an
>> offset calculation routine that, IIRC, executes on the same CPU as the
>> caller.  Thus one can theoretically achieve near 100% CPU scalability
>> when using concat instead of mdraid0.  So the issue isn't partial stripe
>> writes at the media level, but the CPU overhead caused by millions of
>> the little bastards with heavy random IOPS workloads, along with
>> increased numbers of smaller IOs through the SCSI/SATA interface,
>> causing more interrupts thus more CPU time, etc.
>>
>> I've not run into this single stripe thread limitation myself, but have
>> read multiple cases where OPs can't get maximum performance from their
>> storage hardware because their top level mdraid stripe thread is peaking
>> a single CPU in their X-way system.  Moving from RAID10 to a linear
>> concat gets around this limitation for small file random IOPS workloads.
>>  Only when using XFS and a proper AG configuration, obviously.  This is
>> my recollection of Neil's description of the code behavior.  I could
>> very well have misunderstood, and I'm sure he'll correct me if that's
>> the case, or you, or both. ;)
> 
> (oh dear, someone is Wrong on the Internet! Quick, duck into the telephone
> booth and pop out as ....)
> 
> Hi Stan,
>  I think you must be misremembering.
> Neither RAID0 or Linear have any threads involved.  They just redirect the
> request to the appropriate devices.  Multiple threads can submit multiple
> requests down through RAID0 and Linear concurrently.
> 
> RAID1, RAID10, and RAID5/6 are different.  For reads they normally are have
> no contention with other requests, but for writes things to get
> single-threaded at some point.
> 
> Hm... you text above sometime talks about RAID0 vs Linear, and sometimes
> about RAID10 vs Linear.  So maybe you are remembering correctly, but
> presenting incorrectly in part ....

Yes, I believe that's where we are.  My apologies for allowing myself to
become slightly confused.  I'm sure I'm the only human being working
with Linux to ever become so. ;)

Peter kept referencing RAID0 after I'd explicitly referenced RAID10 in
my statement.  I guess I assumed he was simply referring to the striped
component of RAID10, which apparently wasn't the case.

So I did recall correctly that mdraid10 does have some threading
limitations.  So what needs clarification at this point is whether those
limitations are greater than any such limitations with the concatenated
RAID1 pair case using XFS AGs to drive the parallelism.

Thanks for your input Neil, and for your clarifications thus far.

-- 
Stan
