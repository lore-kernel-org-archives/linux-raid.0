From: Chris Lindley <ferg@scotgate.org>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 09:27:20 +0000
Message-ID: <1174123640.12326.10.camel@scotgate>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	 <45FB46DA.7090307@panix.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FB46DA.7090307@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What I think the OP is getting at is that MDADM will create an array
with partitions whose type is not set to FD (Linux Raid Auto), but are
perhaps 83.

The issue with that is that upon a reboot mdadm will not be able to
start the array.  If you use MDADM to manually reassemble the array then
it will work fine. But until you reset the partition type to be FD, you
will have to run this step every time you reboot the machine.

Please note that I'm not disagreeing or agreeing whether the OP's idea
was a good idea, just trying to clarify the issue!

Cheers
Ferg

-- 
                               
  scotgate.org AIM#fergycool jabber#fergy IRC#Ferg MSN#fergycool
  Climb up it, kayak down it + make sure it runs on GNU/Linux
  "cease to exist, giving my goodbye, drive my car into the ocean,
  you think I'm dead, but i sail away, on a wave of mutilation!"





On Fri, 2007-03-16 at 20:39 -0500, berk walker wrote:
> 
> William L. Thomson Jr. wrote:
> > To whom it may concern,
> >
> > 	It seems mdadm does not check, warn, abort, or etc if a partition has
> > an incorrect file system type. This has come up for me on a few
> > occasions while building servers with software raid. On one occasion I
> > had a machine fully up and running on raid partitions that were ext3 not
> > linux auto raid/fd.
> >
> > 	If possible would really be nice if it could do a check for that. Since
> > one usually has to start over when they discover the problem and go to
> > correct it. Since raidtools is not deprecated, others migrating from it
> > on Gentoo are running into it at as well. At the present time mostly
> > developers. Really would not want users running into it :)
> >
> > 	Anyway if that could be addressed that would be great. Not sure if this
> > is the right place for this or not. If not please advise, thank you.
> >
> >   
> Mdadm has no need to know or care about file systems.  It exists on the 
> hardware, /dev level, upon which file systems, if any, are built.
> 
> b-
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

