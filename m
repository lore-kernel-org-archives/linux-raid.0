From: Sebastian Utz <su@rotamente.com>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Mon, 30 Aug 2004 11:40:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093858834.13979.158.camel@slurp>
References: <1093621033.13979.49.camel@slurp>
	 <16690.51386.426771.284290@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16690.51386.426771.284290@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-08-30 at 08:27, Neil Brown wrote:
> On Friday August 27, su@rotamente.com wrote:
> > Hello,
> > 
> > I have a problem with an Software RAID-5 at the top of 4 IDE-Drives
> > connected via 2 Promise UltraTX2 (20268) IDE controller.
> 
> This is not a raid problem.  It is a problem with your filesystem or
> your hardware.
> I think you have reported this for both reiserfs and ext3, in which
> can it is unlikely to be the filesystem.  I guess it could be in the
> generic block layer...
> 
> > 
> > FS is EXT3.
> > Kernel 2.6.8.1	(problem occured with 2.6.7, update didn't helped)
> > CPU: Pentium II 400
> > Mainboard: Asus P2B-S
> > 
> > After 29% usage, I've got an Kernel oops and system stalls:
> > -------- snip start -------------
> > Aug 27 16:30:18 gharb kernel: attempt to access beyond end of device
> > Aug 27 16:30:18 gharb kernel: md0: rw=1, want=6917529027856096120,
> > limit=241215360
> 
> 6917529027856096120 is 600000000CD0DB78 in hex.
> 0xCD0DB78 is 215014264 which is not beyond the end of the device.
> It looks like  2 extra bits have been set at the top of the address.
> This could be due to bad memory (though that is more commonly a
> single-bit error, not a double bit error), or it could be the
> filesystem send a bad request, possibly due to bad indexing
> information that has previously been stored on disk.
> 
> I recommend running memtest for a while and confirming that it isn't a
> hardware error, and then possibly following up on
> linux-kernel@vger.kernel.org.
> 

Ok, thanks for that hint, I've run memtest and it gives me a lot of
error-counts!! Thats it!
Sorry, next time I'll get sure its not a hardware problem before posting
a message.. 

Thanks a lot!!!
sebastian

