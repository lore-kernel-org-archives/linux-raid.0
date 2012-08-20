From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Sun, 19 Aug 2012 23:44:25 -0500
Message-ID: <5031C0A9.60803@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com> <20120820100134.22b2b056@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120820100134.22b2b056@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>, Miquel van Smoorenburg <mikevs@xs4all.net>, Linux RAID <linux-raid@vger.kernel.org>, LKML@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-raid.ids

I'm copying Dave C. as he apparently misunderstood the behavior of
md/RAID6 as well.  My statement was based largely on Dave's information.
 See [1] below.

On 8/19/2012 7:01 PM, NeilBrown wrote:
> On Sun, 19 Aug 2012 18:34:28 -0500 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:

> Since we are trying to set the record straight....

Thank you for finally jumping in Neil--had hoped to see your
authoritative information sooner.

> md/RAID6 must read all data devices (i.e. not parity devices) which it is not
> going to write to, in an RWM cycle (which the code actually calls RCW -
> reconstruct-write).

> md/RAID5 uses an alternate mechanism when the number of data blocks that need
> to be written is less than half the number of data blocks in a stripe.  In
> this alternate mechansim (which the code calls RMW - read-modify-write),
> md/RAID5 reads all the blocks that it is about to write to, plus the parity
> block.  It then computes the new parity and writes it out along with the new
> data.

>> [1}The only thing that's not clear at this point is if md/RAID6 also
>> always writes back all chunks during RMW, or only the chunk that has
>> changed.

> Do you seriously imagine anyone would write code to write out data which it
> is known has not changed?  Sad. :-)

From a performance standpoint, absolutely not.  Though I wouldn't be
surprised if there are a few parity RAID implementations out there that
do always write a full stripe for other reasons, such as catching media
defects as early as possible, i.e. those occasions where bits in a
sector may read just fine but can't be re-magnetized.  I'm not
championing such an idea, merely stating that others may use this method
for this or other reasons.


[1]
On 6/25/2012 9:30 PM, Dave Chinner wrote:
> You can't, simple as that. The maximum supported is 256k. As it is,
> a default chunk size of 512k is probably harmful to most workloads -
> large chunk sizes mean that just about every write will trigger a
> RMW cycle in the RAID because it is pretty much impossible to issue
> full stripe writes. Writeback doesn't do any alignment of IO (the
> generic page cache writeback path is the problem here), so we will
> lamost always be doing unaligned IO to the RAID, and there will be
> little opportunity for sequential IOs to merge and form full stripe
> writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
>
> IOWs, every time you do a small isolated write, the MD RAID volume
> will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> Given that most workloads are not doing lots and lots of large
> sequential writes this is, IMO, a pretty bad default given typical
> RAID5/6 volume configurations we see....


-- 
Stan

