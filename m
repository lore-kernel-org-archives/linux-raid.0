From: NeilBrown <neilb@suse.de>
Subject: Re: Reshaping RAID-0?
Date: Sat, 5 Feb 2011 12:01:18 +1100
Message-ID: <20110205120118.18072fef@notabene.brown>
References: <AANLkTinWzDmEHYWoqFeEoXqQhutj=kG-tgJd7BqERgNF@mail.gmail.com>
	<4D4C9B8E.4090502@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4C9B8E.4090502@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 05 Feb 2011 00:36:30 +0000 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 04/02/2011 23:32, Patrick J. LoPresti wrote:
> > Well, it has been 11 months since I last asked
> > (http://www.spinics.net/lists/raid/msg27676.html), and some recent
> > patches mention this in the context of "imsm", whatever that is...
> >
> > So, is it possible to add a disk to a Linux md RAID-0 array and
> > re-stripe?  If so, what is the procedure and the required kernel/mdadm
> > version(s)?
> >
> > If not, and if I want to contribute to an implementation effort, where
> > would I begin?
> >
> > Thanks!
> 
> I think the capability is in mdadm 3.2, a developer-only release about 4 
> days ago, or it's in Neil Brown's 3.2 devel branch. Take a closer look 
> at the list archives for the last few days.
> 
> As for using it, it'll be the usual syntax, e.g. `mdadm /dev/mdX --add 
> /dev/newdisc; mdadm /dev/mdX --grow --raid-disks=3`.
> 
> Hope this helps.

It's heading in the right direction, but there is an important issue which is
as yet completely unimplemented.

You cannot --add a device to a RAID0 - the kernel won't let you because it
doesn't understand what that means - RAID0 arrays cannot have spares.

So the usage will have to be something like:


 mdadm /dev/md0X --grow --raid-disks=3 --add /dev/newdisc

mdadm will then need to:

 - convert the RAID0 to RAID4
 - disable recovery from auto-starting
 - add /dev/newdisc to the array as a spare (but recovery won't start)
 - request a size change to one extra disk
 - start the reshape
 - wait for the reshape to complete
 - convert back to RAID0

The latest kernel can handle each of those steps, should you could do this
'manually' by writing to /sys for some key steps and using mdadm for others.

But mdadm cannot do all of this yet.  It can or almost can) for 'imsm' which
is Intel's Matrix Storage Manager as the metadata handler for that can cope
with spares associated with a RAID0 ... (sort of - it's complicated).

I'll hopefully have this sorted for 3.2.1.

NeilBrown
