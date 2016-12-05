From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Sun, 4 Dec 2016 20:46:55 -0500
Message-ID: <091751d5-27fc-0a6f-60a4-86401df33ac5@nasa.gov>
References: <56742652.5040304@nasa.gov>
 <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
 <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov>
 <8737uv4fz6.fsf@notabene.neil.brown.name> <5678A908.6070401@bnl.gov>
 <87wps72k8o.fsf@notabene.neil.brown.name>
 <CAB9NSeXhoHd3_BDRrWAsBrW0Dj2=NucyUFt8pSP0zB5K=RkUOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB9NSeXhoHd3_BDRrWAsBrW0Dj2=NucyUFt8pSP0zB5K=RkUOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Tejas Rao <raot@bnl.gov>, Scott Sinno <scott.sinno@nasa.gov>
List-Id: linux-raid.ids

Hi Robert,

I don't know the answer to the question, but I had to refresh my memory 
on the issue and here are my thoughts on it:

I dug it up and the issue with clustered RAID5/6 is one of stripe 
locking (http://www.spinics.net/lists/raid/msg51020.html). If two 
different nodes say write 4k to 2 different locations within a 128k 
stripe there's a race condition and best case you'll lose one of the 
writes, worst case you'd entirely corrupt the stripe. As was pointed out 
on the thread I linked to the performance implications of locking a 
stripe could be dire. If you'd like to do 1GiB/s to an array (not 
unreasonable for even a modest drive count) with a chunk size of 128KiB 
that's 8,192 locks per second.

The approach I was going to take (but I'm no longer working on the 
project that required it) was to use pacemaker to co-ordinate failover 
of the md devices between nodes. Pacemaker would co-ordinate the 
"serving" of the LUNs via SCST and on the passive node would present a 
pair of "dummy" devices. ALUA would be used to inform the clients of 
which was the active path. On the clients multipath would be required to 
pull it all together. I had started work on the pacemaker failover of 
the SCST LUNs and have some patches to the available OCF resource agents 
to make the progress I did. I can send those to you if you'd like. It's 
rather precarious and without extensive testing I don't trust it to not 
eat all your data.

The only thing I know of that could, out of the box, perhaps do what 
you're asking is Raidix (http://www.raidix.com/) and that's based purely 
on advertised specifications.

I agree with you, though, if it clustered md raid6/60 could be made to 
work and be performant I think it would be an asset to the Linux community.

-Aaron

On 12/2/16 1:03 PM, Robert Woodworth wrote:
> Excuse me for being late to the party on this subject, but is the idea
> of clustered RAID5/6 alive or dead?
>
> I have a need for such a feature. I'm in development on SAS JBODs with
> large drive counts, 60 and 90 drives per JBOD. We would like to support
> multi-host connectivity in an active/active fashion with MD RAID60.
> This clustered MD RAID can and should be a nice alternative to HW RAID
> solutions like LSI/Avago "Syncro" MegaRAID.
>
> I currently have the hardware and time to help develop and test the
> clustered RAID5/6.
> I just finished up building a test cluster of 2 nodes with the
> cluster-md RAID1.  Worked fine with gfs2 on top.
>
>
> My current real job is firmware on these SAS JBODS. I have many years of
> Linux experience and have developed (years ago) some kernel modules for
> a custom FPGA based PCIe cards.
>
>
> On Mon, Dec 21, 2015 at 9:13 PM, NeilBrown <neilb@suse.de
> <mailto:neilb@suse.de>> wrote:
>
>     On Tue, Dec 22 2015, Tejas Rao wrote:
>
>     > Each GPFS disk (block device) has a list of servers associated with it.
>     > When the first storage server fails (expired disk lease), the storage
>     > node is expelled and a different server which also sees the shared
>     > storage will do I/O.
>
>     In that case something probably could be made to work with md/raid5
>     using much of the cluster support developed for md/raid1.
>
>     The raid5 module would take a cluster lock that covered some region of
>     the array and would not need to release it until a fail-over happened.
>     So there would be little performance penalty.
>
>     The simplest approach would be to lock the whole array.  This would
>     preclude the possibility of different partitions being accessed from
>     different nodes.  Maybe that is not a problem.  If it were, a solution
>     could probably be found but there would be little point searching for a
>     solution before a clear need was presented.
>
>     >
>     > In the future ,we would prefer to use linux raid (RAID6) in a shared
>     > environment shielding us against server failures. Unfortunately we can
>     > only do this after Redhat supports such an environment with linux raid.
>     > Currently they do not support this even in an active/passive environment
>     > (only one server can have a md device assembled and active regardless).
>
>     Obviously that is something you would need to discuss with Redhat.
>
>     Thanks,
>     NeilBrown
>
>

-- 
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776
