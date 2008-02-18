From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: suns raid-z / zfs
Date: Mon, 18 Feb 2008 06:33:19 +0100
Message-ID: <20080218053319.GA18863@rap.rap.dk>
References: <20080217160403.GA15710@rap.rap.dk> <18361.1168.473685.214133@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18361.1168.473685.214133@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 18, 2008 at 03:07:44PM +1100, Neil Brown wrote:
> On Sunday February 17, keld@dkuug.dk wrote:
> > Hi
> > 
> 
> > It seems like a good way to avoid the performance problems of raid-5
> > /raid-6
> 
> I think there are better ways.

Interesting! What do you have in mind?

and what are the problems with zfs?

> > 
> > But does it stripe? One could think that rewriting stripes
> > other places would damage the striping effects.
> 
> I'm not sure what you mean exactly.  But I suspect your concerns here
> are unjustified.

More precisely. I understand that zfs always write the data anew.
That would mean at other blocks on the partitions, for the logical blocks
of the file in question. So the blocks on the partitions will not be
adjacant. And striping will not be possible, generally.
> 
> > 
> > Can the code be lifted to Linux? I understand that it is already in
> > freebsd. Does Suns licence prevent this?
> 
> My understanding is that the sun license prevents it.
> 
> However raid-z only makes sense in the context of a specific
> filesystem such as ZFS.  It isn't something that you could just layer
> any filesystem on top of.

That is understood.
> 
> > 
> > And could something like this be built into existing file systems like
> > ext3 and xfs? They could have a multipartition layer in their code, and
> > then the heuristics to optimize block access could also apply to stripe
> > access.
> 
> I doubt it, but I haven't thought deeply enough about it to see if
> there might be some relatively non-intrusive way.

Hmm, I think this is not for the raid layer to do, as I understand it.

Best regards
keld
