From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Mon, 30 Aug 2004 16:27:06 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16690.51386.426771.284290@cse.unsw.edu.au>
References: <1093621033.13979.49.camel@slurp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Utz on Friday August 27
To: Sebastian Utz <su@rotamente.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 27, su@rotamente.com wrote:
> Hello,
> 
> I have a problem with an Software RAID-5 at the top of 4 IDE-Drives
> connected via 2 Promise UltraTX2 (20268) IDE controller.

This is not a raid problem.  It is a problem with your filesystem or
your hardware.
I think you have reported this for both reiserfs and ext3, in which
can it is unlikely to be the filesystem.  I guess it could be in the
generic block layer...

> 
> FS is EXT3.
> Kernel 2.6.8.1	(problem occured with 2.6.7, update didn't helped)
> CPU: Pentium II 400
> Mainboard: Asus P2B-S
> 
> After 29% usage, I've got an Kernel oops and system stalls:
> -------- snip start -------------
> Aug 27 16:30:18 gharb kernel: attempt to access beyond end of device
> Aug 27 16:30:18 gharb kernel: md0: rw=1, want=6917529027856096120,
> limit=241215360

6917529027856096120 is 600000000CD0DB78 in hex.
0xCD0DB78 is 215014264 which is not beyond the end of the device.
It looks like  2 extra bits have been set at the top of the address.
This could be due to bad memory (though that is more commonly a
single-bit error, not a double bit error), or it could be the
filesystem send a bad request, possibly due to bad indexing
information that has previously been stored on disk.

I recommend running memtest for a while and confirming that it isn't a
hardware error, and then possibly following up on
linux-kernel@vger.kernel.org.


NeilBrown

