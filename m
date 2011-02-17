From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 14:10:17 +1100
Message-ID: <20110217141017.01e30eab@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<20110216202939.GA2756@lazy.lzy>
	<20110217084826.77f4dbf1@notabene.brown>
	<4D5C6AAF.1040600@turmel.org>
	<20110217115257.28a8d174@notabene.brown>
	<4D5C768A.1010502@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C768A.1010502@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 20:14:50 -0500 Phil Turmel <philip@turmel.org> wrote:

> On 02/16/2011 07:52 PM, NeilBrown wrote:

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

To see what I am strongly against having the kernel make automatic
corrections like this, see

    http://neil.brown.name/blog/20100211050355


> 
> Also, the comparison would have to ignore "neutral bytes", where P & Q
> happened to be correct for that byte position.
> 
> > The point I'm trying to get to is that the result of this RAID6 calculation
> > isn't a simple "that device is bad".  It is a block of data that needs to be
> > interpreted.
> > 
> > I'd rather have user-space do that interpretation, so it may as well do the
> > calculation too.
> > 
> > If you wanted to do it in the kernel, you would need to be very clear about
> > what information you provide, what it means exactly, and why it is sufficient.
> 
> Given that the hardware is going to do error correction and checking at a
> sector size granularity, and the kernel would in fact rewrite that sector using
> this calculation if the hardware made a "fairly strong" statement that it can't
> be trusted, I'd argue that rewriting the sector is appropriate.

You the RAID6 calculation tells you is that something cannot be trusted.  It
doesn't tell you what.  It could be the controller, the cable, the drive
logic, or the rust on the media.  Without the knowledge, correction can be
dangerous.

NeilBrown



> 
> Any corrective action that isn't consistent at the sector level should be punted.
> I'm very curious what percentage that would be in production environments.
> 
> Phil

