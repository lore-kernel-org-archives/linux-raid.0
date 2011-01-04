From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 4 Jan 2011 22:15:58 +1100
Message-ID: <20110104221558.36fd1d6d@notabene.brown>
References: <20110103163213.GC17455@fi.muni.cz>
	<20110104162437.31dae9c9@notabene.brown>
	<20110104082944.GK17455@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104082944.GK17455@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 4 Jan 2011 09:29:44 +0100 Jan Kasprzak <kas@fi.muni.cz> wrote:

> NeilBrown wrote:
> : The md1_raid10 process is probably spending lots of time in memcmp and memcpy.
> : The way it works is to read all blocks that should be the same, see if they
> : are the same and if not, copy on to the orders and write those other (or in
> : your case "that other").
> 
> 	According to dmesg(8) my hardware is able to do XOR
> at 9864 MB/s using generic_sse, and 2167 MB/s using int64x1. So I assume
> memcmp+memcpy would not be much slower. According to /proc/mdstat, the resync
> is running at 449 MB/s. So I expect just memcmp+memcpy cannot be a bottleneck
> here.

Maybe ... though I'm not at all sure that the speed-test filters out cache
effects properly...

> 
> : It might be appropriate to special-case some layouts and do 'read one, write
> : other' when that is likely to be more efficient (patches welcome).
> : 
> : I'm surprised that md1_resync has such a high cpu usage though - it is just
> : scheduling read requests, not actually doing anything with data.
> 
> 	Maybe it is busy-waiting in some spinlock or whatever?
> Can I test it somehow? I still have several days before I have to
> put the server in question to the production use.

Nothing particularly useful springs to mind.

It might be interesting to try creating arrays is 2,4,6,8,10.... devices and
see how the resync speed changes with the number of devices.  You could even
graph that - I love graphs.  I cannot say if it would provide useful info or
not.

> 
> 	One more question, though: current mdadm creates the RAID-10
> array with 512k chunk size, while XFS supports onlo 256k chunks (sunit).
> I think the default value should be supported by XFS (either by modifying
> XFS which I don't know how hard it could be, or by changing the default
> in mdadm, which is trivial).

I doubt that XFS would suffer from using a 256k sunit with a 512k chunk
RAID10.  If you really want to know how the two numbers interact I suggest
you ask on the XFS mailing list - the man page doesn't seem particularly
helpful (and doesn't even mention a maximum).

I am unlikely to change the default chunksize, but if you find that XFS would
benefit from md arrays using at most 256K chunks, I could put a note in the
man page for mdadm....

NeilBrown



> 
> 	Thanks,
> 
> -Yenya
> 

