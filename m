From: Philip Molter <philip@corp.texas.net>
Subject: Re: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 12:07:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411BA3D8.5030901@corp.texas.net>
References: <200408121522.i7CFM7311834@watkins-home.com> <411B9A2C.6090108@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411B9A2C.6090108@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Anyway - the question remains - would this be the right approach?
> 
> Hmm - I wonder what would be needed to make the resync code do this...

No, it wouldn't.  In RAID5 implementations, parity isn't recalculated 
when you write to a RAID,  It's updated.  My understanding is that 
typical implementations are, *VERY* basically:

read the old data
xor with the new data
read the parity data
xor with the parity data
write the new data
write the new parity data

Thus a RAID5 write is really two disk reads and two disk writes, which 
is why RAID5 is expensive for writing.  Under this scheme, if the parity 
is bad, and you write data to "update" it, it's still bad because you 
haven't recalculated anything.  If the parity is good, everything stays 
in sync.

If you were to truly recalculate parity every time you wrote to a block, 
it'd be something like:

write the new data
read the corresponding data blocks from the other drives
recalculate parity based on all blocks
write the new parity data

That would be n-1 reads and 2 writes for every write, which would get 
expensive as your number of drives increased.  It's something like this 
that the update=resync option in mdadm does, that is it reads every 
drive's data and actually recalculates the parity based on that.

Philip
