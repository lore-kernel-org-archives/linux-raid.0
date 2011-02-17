From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 20:56:21 +0100
Message-ID: <20110217195621.GA3296@lazy.lzy>
References: <20110216212751.51a294aa@notabene.brown>
 <20110216202939.GA2756@lazy.lzy>
 <20110217084826.77f4dbf1@notabene.brown>
 <4D5C6AAF.1040600@turmel.org>
 <20110217115257.28a8d174@notabene.brown>
 <4D5C768A.1010502@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5C768A.1010502@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > So when you do the computation on all of the bytes in all of the blocks you
> > get a block full of answers.
> > If the answers are all the same - that tells you something fairly strong.
> > If they are a "all different" then that is also a fairly strong statement.
> > But what if most are the same, but a few are different?  How do you interpret
> > that?
> 
> Actually, I was thinking about that.  (You suckered me into reading that PDF
> some weeks ago.)  I would be inclined to allow the kernel to make corrections
> where "all the same" covers individual sectors, per the sector size reported
> by the underlying device.

I do agree with Neil on this.
User space should collect the data, perform statistics
and give suggestions.
After that there should be a mechanism, at this point in
kernel space, I guess, capable of correcting one single
chunk of one device.

> Also, the comparison would have to ignore "neutral bytes", where P & Q
> happened to be correct for that byte position.

<shameless advertisement>
Have a look at the patch I submitted to "restripe.c", it
should cover the interesting cases.
Even if more statistics could be applied.
</shameless advertisement>
 
> Given that the hardware is going to do error correction and checking at a
> sector size granularity, and the kernel would in fact rewrite that sector using
> this calculation if the hardware made a "fairly strong" statement that it can't
> be trusted, I'd argue that rewriting the sector is appropriate.

The problem could be in the interface (it happened to me)
and not in the disk. So, there will be no error correction,
at this point, from the device.
 
> Any corrective action that isn't consistent at the sector level should be punted.
> I'm very curious what percentage that would be in production environments.

Yeah, me too.

bye,

-- 

piergiorgio
