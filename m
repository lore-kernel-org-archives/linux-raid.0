From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 16:05:30 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310281605.30225.maarten@vbvb.nl>
References: <3F9DAD4C.3000002@verizon.net> <200310281506.32013.maarten@vbvb.nl> <Pine.LNX.4.56.0310281418490.25548@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0310281418490.25548@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 15:25, you wrote:
> On Tue, 28 Oct 2003, maarten van den Berg wrote:
> > On Tuesday 28 October 2003 09:26, Gordon Henderson wrote:
> > > On Mon, 27 Oct 2003, berk walker wrote:
> > >
> > > Good luck with your promise board (what type is it?) I've had a lot of
> > > problems with them (kernels 2.4.20-22) They seem to work, but under
> > > heavy load, I see processes getting stuck in "D" state (eg. nfsd or
> > > anything doing lots of disk IO) Most of the time they recover, but I've
> > > load a disk partition on more than one occasion (saved by raid, and it
> > > re-built OK after a reboot). I've seen this in 2 different servers and
> > > tried both Intel and AMD CPUs. Tonight I try a set of different PCI IDE
> > > controllers in one server to see if that helps it.
> >
> > Promise cards do suck somewhat -albeit I use them- but what else is there
> > ? The highpoint-equipped cards are even more sucky in many cases.
>
> Hm. I'm just about to try a pair of HighPoint cards tonight...

Well, you might be lucky. My own experiences with them were with older cards 
and chipsets, from years back.  Stuff changes.  :-)

> > > It's hard to tell if it's a real hardware problem or a software one
> > > (the Promise driver being fairly new, patched in at 2.4.20, included in
> > > 2.4.22)
> >
> > Ehm, what ???  You're probably talking about the driver for the fasttrack
> > cards who are -in their own respect- raid cards. But if you use a 'plain'
> > card like the ultra it's just used as an additional IDE channel. That has
> > worked long long before 2.4.20 and it is what I use.  No sense in buying
> > a pricey fasttrack if you're not going to use the raid but use the md
> > tools instead.
>
> The cards I have identify in /proc/pci as:
>
>   Unknown mass storage controller: Promise Technology, Inc. 20269 (#2) (rev
> 2)

That's an Ultra 133 TX, I have the same one.

> They aren't RAID cards (as far as I'm aware!) and I needed to apply the AC
> patches to 2.4.20 to get them to be recognised. (These patches are
> integrated into 2.4.22)

Hmm.  Ok.  Weird...  My antique SuSE linux distro 7.3 recognized them right 
away, and so did the latest SuSE 8.2 I installed over that yesterday.
SuSE has been known to apply a lot of patches to their kernel though...

> Gordon

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
