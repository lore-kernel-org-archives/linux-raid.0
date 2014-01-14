From: David Brown <david.brown@hesbynett.no>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Tue, 14 Jan 2014 09:54:56 +0100
Message-ID: <52D4FB60.8050004@hesbynett.no>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org> <1388873143.7641.20.camel@vessel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388873143.7641.20.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/14 23:05, Fabian Knorr wrote:
> Hi, Phil,
> 
> thank you very much for your reply.
> 
>> Side note: If you have a live spare available for a raid5, there's no
>> good reason not to reshape to a raid6, and very good reasons to do so.
> 
> I was worried that RAID6 would incur a significant load on the CPU,
> especially if one disk fails. The system is a single-core Intel Atom.
> 

Recovery of a single disk failure with RAID6 is the same as for RAID5 -
if a data block is missing, md will use the other data blocks and the
RAID5 xor parity for the recovery.  It only needs to do "hard" RAID6
recovery if there are /two/ disks (or blocks) that have failed.

RAID6 parity generation is harder than RAID5 generation, but it is not
/that/ hard, even for a single core Atom - especially if the cpu is not
doing many other tasks.  You might feel it on big writes, or during a
resync / rebuild.

Other than that, the only disadvantage of RAID6 is that you don't get
the RMW behaviour on partial stripe writes (I believe this is under
development, but I don't know the current status).  With RAID5, if you
write to a single block in a stripe then md can read the old block and
the old parity, then write the new block and the new parity rather than
having to read in the whole stripe.  RAID6 always has to read the whole
stripe to create new parities.  This means that small writes will be
slower on RAID6 than RAID5.

However, if you are doing so many small writes that this is an important
factor, you are probably better off with RAID10.

So IMHO if you have the drives for RAID5 + spare, you are almost always
better off using RAID6.

