From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 21:47:47 +0100
Message-ID: <jsh8b2-5g6.ln1@news.it.uc3m.es>
References: <41E17117.2090500@tls.msk.ru> <200501092028.j09KSr918180@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> It is on Neil's wish list (or to do list)!  Mine too!

What is? Can you please be specific?

> From Neil Brown:
> 
> http://marc.theaimsgroup.com/?l=linux-raid&m=110055742813074&w=2

If you are talking about (and I am guessing, thanks to the uniform
sensation of opaque experientiality that passes over me when I see the
format of your posts, or the lacl of it) reading from the other disk
when one sector read fails on the first, that appears to be in 2.6.3 at
least, as my reading of the code goes.  What neil says in your reference

   you can let the kernel kick out a drive that has a read error, let
   user-space have a quick look at the drive and see if it might be a
   recoverable error, and then give the drive back to the kernel

is true.  As far as I can see from a quick scan of the (raid1) code, he
DOES kick a disk out on read error, but also DOES RETRY the read from
another disk for that sector.  Currently he does that in the resync
thread. 

He needs a list of failed reads and only needs to kick the disk when
recovery fails.

At the present time it is trivial to add a write as well as a read on a
retry.

I can add the read accounting.

Neil's comments indicate that he is interested in doing this in a
generic way. 

So am I, but I'll settle for "non-generic" first.

Peter

