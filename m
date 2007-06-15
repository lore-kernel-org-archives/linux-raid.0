From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 13:58:20 +1000
Message-ID: <18034.3676.477575.490448@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from david@lang.hm on Thursday June 14
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 14, david@lang.hm wrote:
> On Fri, 15 Jun 2007, Neil Brown wrote:
> 
> > On Thursday June 14, david@lang.hm wrote:
> >> what is the limit for the number of devices that can be in a single array?
> >>
> >> I'm trying to build a 45x750G array and want to experiment with the
> >> different configurations. I'm trying to start with raid6, but mdadm is
> >> complaining about an invalid number of drives
> >>
> >> David Lang
> >
> > "man mdadm"  search for "limits".  (forgive typos).
> 
> thanks.
> 
> why does it still default to the old format after so many new versions? 
> (by the way, the documetnation said 28 devices, but I couldn't get it to 
> accept more then 27)

Dunno - maybe I can't count...

> 
> it's now churning away 'rebuilding' the brand new array.
> 
> a few questions/thoughts.
> 
> why does it need to do a rebuild when makeing a new array? couldn't it 
> just zero all the drives instead? (or better still just record most of the 
> space as 'unused' and initialize it as it starts useing it?)

Yes, it could zero all the drives first.  But that would take the same
length of time (unless p/q generation was very very slow), and you
wouldn't be able to start writing data until it had finished.
You can "dd" /dev/zero onto all drives and then create the array with
--assume-clean if you want to.  You could even write a shell script to
do it for you.

Yes, you could record which space is used vs unused, but I really
don't think the complexity is worth it.

> 
> while I consider zfs to be ~80% hype, one advantage it could have (but I 
> don't know if it has) is that since the filesystem an raid are integrated 
> into one layer they can optimize the case where files are being written 
> onto unallocated space and instead of reading blocks from disk to 
> calculate the parity they could just put zeros in the unallocated space, 
> potentially speeding up the system by reducing the amount of disk I/O.

Certainly.  But the raid doesn't need to be tightly integrated
into the filesystem to achieve this.  The filesystem need only know
the geometry of the RAID and when it comes to write, it tries to write
full stripes at a time.  If that means writing some extra blocks full
of zeros, it can try to do that.  This would require a little bit
better communication between filesystem and raid, but not much.  If
anyone has a filesystem that they want to be able to talk to raid
better, they need only ask...
 
> is there any way that linux would be able to do this sort of thing? or is 
> it impossible due to the layering preventing the nessasary knowledge from 
> being in the right place?

Linux can do anything we want it to.  Interfaces can be changed.  All
it takes is a fairly well defined requirement, and the will to make it
happen (and some technical expertise, and lots of time .... and
coffee?).

NeilBrown
