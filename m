From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 4 Jan 2011 09:29:44 +0100
Message-ID: <20110104082944.GK17455@fi.muni.cz>
References: <20110103163213.GC17455@fi.muni.cz> <20110104162437.31dae9c9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110104162437.31dae9c9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
: The md1_raid10 process is probably spending lots of time in memcmp and memcpy.
: The way it works is to read all blocks that should be the same, see if they
: are the same and if not, copy on to the orders and write those other (or in
: your case "that other").

	According to dmesg(8) my hardware is able to do XOR
at 9864 MB/s using generic_sse, and 2167 MB/s using int64x1. So I assume
memcmp+memcpy would not be much slower. According to /proc/mdstat, the resync
is running at 449 MB/s. So I expect just memcmp+memcpy cannot be a bottleneck
here.

: It might be appropriate to special-case some layouts and do 'read one, write
: other' when that is likely to be more efficient (patches welcome).
: 
: I'm surprised that md1_resync has such a high cpu usage though - it is just
: scheduling read requests, not actually doing anything with data.

	Maybe it is busy-waiting in some spinlock or whatever?
Can I test it somehow? I still have several days before I have to
put the server in question to the production use.

	One more question, though: current mdadm creates the RAID-10
array with 512k chunk size, while XFS supports onlo 256k chunks (sunit).
I think the default value should be supported by XFS (either by modifying
XFS which I don't know how hard it could be, or by changing the default
in mdadm, which is trivial).

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
