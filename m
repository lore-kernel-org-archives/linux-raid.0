From: Gordon Henderson <gordon@drogon.net>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 15:10:29 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310281508110.25548@unicorn.drogon.net>
References: <3F9DAD4C.3000002@verizon.net> <200310281506.32013.maarten@vbvb.nl>
 <Pine.LNX.4.56.0310281418490.25548@unicorn.drogon.net> <200310281605.30225.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310281605.30225.maarten@vbvb.nl>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Oct 2003, maarten van den Berg wrote:

> > > Promise cards do suck somewhat -albeit I use them- but what else is there
> > > ? The highpoint-equipped cards are even more sucky in many cases.
> >
> > Hm. I'm just about to try a pair of HighPoint cards tonight...
>
> Well, you might be lucky. My own experiences with them were with older cards
> and chipsets, from years back.  Stuff changes.  :-)

I'll let you know how I get on...

> > The cards I have identify in /proc/pci as:
> >
> >   Unknown mass storage controller: Promise Technology, Inc. 20269 (#2) (rev
> > 2)
>
> That's an Ultra 133 TX, I have the same one.
>
> > They aren't RAID cards (as far as I'm aware!) and I needed to apply the AC
> > patches to 2.4.20 to get them to be recognised. (These patches are
> > integrated into 2.4.22)
>
> Hmm.  Ok.  Weird...  My antique SuSE linux distro 7.3 recognized them right
> away, and so did the latest SuSE 8.2 I installed over that yesterday.
> SuSE has been known to apply a lot of patches to their kernel though...

I use Debian and stock kernels, so that might be it. It was intersting to
bring up - I had to use the on-board IDE controller to get the system
booted, then compile a kernel with driver for the PCI controller, then
move the drive... Then build all the RAID stuff and make it boot off RAID.
One day Debian will have an install that will work directly onto RAID, but
not yet!

Gordon
