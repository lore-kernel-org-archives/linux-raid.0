From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:24:12 +1100
Message-ID: <20110217082412.51afa2a6@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BDB84.8050706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5BDB84.8050706@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 09:13:24 -0500 Joe Landman <joe.landman@gmail.com> wrote:

> On 02/16/2011 05:27 AM, NeilBrown wrote:
> >
> > I all,
> >   I wrote this today and posted it at
> > http://neil.brown.name/blog/20110216044002
> >
> > I thought it might be worth posting it here too...
> 
> 
> Any possibility of getting a hook for a read/write/compare checksum in 
> this?  I'd be happy to commit some time to this if I knew where to begin.

"read/write/compare checksum" is not a lot of words so I may well not be
understanding exactly what you mean, but I guess you are suggesting that we
could store (say) a 64bit hash of each 4K block somewhere.
e.g. Use 513 4K blocks to store 512 4K blocks of data with checksums.
When reading a block, read the checksum too and report an error if they
don't match.  When writing the block, calculate and write the checksum too.

This is already done by the disk drive - I'm not sure what you hope to gain
by doing it in the RAID layer as well.

Doing it in the filesystem as well does make sense and then you get an
end-to-end checksum which can be useful.  But the RAID layer doesn't really
give you that.

And doing it in the RAID layer is problematic because you cannot commit both
checksum and data at the same time (like you can in the hardware).
In the filesystem you could use whatever journalling mechanism you use to
commimt both effectively at the same time.

Doing this in the RAID layer could possibly piggy-back off the write-intent
bitmap so that we re-generate all checksums for all blocks which have a bit
set - which means all blocks that were being written when the power went off.
But that is probably the most likely time for corruption to occur, and it is
the one time when we wouldn't detect it...

So I'm not sure I see real value in doing this in the RAID layer.  But maybe
I misunderstand you, or maybe you can see a better design than me, which
actually works well.

So if you have more words, I'd be keen to read them :-)



> 
> Also, very interested in hooks to do RAID and similar computations in 
> user space (so we can play with functionality without causing problems 
> with a kernel).  Does this external capability exist now?  Would it be 
> hard to include?  Again, something we'd be interested in committing some 
> time to if we could get a shove in the right direction.

Again, I'm not really sure what you are suggesting.  But if you want to
experiment with some other RAID computations, I suggest either experimenting
entirely in userspace, or entirely in the kernel.  Making interfaces between
the two tends to be quite challenging.


Thanks,
NeilBrown
