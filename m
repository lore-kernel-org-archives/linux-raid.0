From: David Brown <david.brown@hesbynett.no>
Subject: Re: [RFC]raid5: multiple thread handle stripe
Date: Tue, 17 Jul 2012 16:17:16 +0200
Message-ID: <500573EC.4040409@hesbynett.no>
References: <20120709080024.GA801@kernel.org> <20120716144746.08d26926@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716144746.08d26926@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On 16/07/12 06:47, NeilBrown wrote:
> On Mon, 9 Jul 2012 16:00:24 +0800 Shaohua Li<shli@kernel.org>  wrote:
>
>> I had another implementation of raid5 mult-thread. The basic idea is to record
>> stripe submitted CPU. Each cpu has a thread, which only handles stripes
>> submitted from this cpu.
>>
>> Dan mentioned similar idea several day ago. I used to think we need make
>> conf->device_lock per-cpu to make this work, but turn out that isn't required.
>> Simply using percpu list and still using global device_lock works here.
>> Performance is good too.
>>
>> This is a RFC patch, I'll resubmit in a better reviewable way if you like the idea.
>
> I mostly like this, thanks.  It seems to take a fairly simple approach -
> having a single list of pending stripes and each thread just takes the ones
> that are relevant for it.
>
> I'm not convinced of the idea of having one thread for every CPU though. I
> wonder if we should be more NUMA-aware.
> E.g. on an Intel core with SMT we want at most one thread per core, not one
> thread per control thread.
> Similarly in a larger NUMA machine we might want one or 2 threads per node
> even if they have multiple CPUs.  Does that seem reasonable?
>

Raid can't be the only task in the kernel that has this sort of balanced 
requirement of multiple threads, but for which one thread per virtual 
cpu would be overkill.  A brief look at my own system shows multiple 
per-cpu threads for things like block devices and ext4 systems, which 
would surely have the same requirements here.  It strikes me that if it 
is currently not considered excessive to have one thread per cpu per 
mounted ext4 filesystem, for example, then one thread per cpu per raid 
device is not going to have excessive overheads either.  Conversely, if 
it /does/ make sense to limit the thread count for raid on larger 
machines, then perhaps the same logic should be used for other related 
tasks such as block drivers and filesystem threads.

mvh.,

David

