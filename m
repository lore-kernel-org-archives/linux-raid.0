From: djani22@dynamicweb.hu
Subject: Re: Found a new bug!
Date: Thu, 18 Aug 2005 17:39:01 +0200
Message-ID: <007001c5a40b$03f7e3a0$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene><E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au><009001c58ac8$9ab25d40$0400a8c0@LocalHost><17114.55335.687696.686786@cse.unsw.edu.au><03e501c5a120$f3a79a00$0400a8c0@LocalHost><17151.60931.26972.713074@cse.unsw.edu.au><011101c5a187$3bc8cf00$0400a8c0@LocalHost> <17156.4079.67097.825741@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, August 18, 2005 6:34 AM
Subject: Re: Found a new bug!


> On Monday August 15, djani22@dynamicweb.hu wrote:
> > Thanks, I will test it, when I can...
> >
> > In this moment, my system is an working online system, and now only one
8TB
> > space what I can use...
> > Thats right, maybe I can built linear array from only one soure
device,but:
> > My first problem is, on my 8TB device is already exists XFS filesystem,
with
> > valuable data, what I can't backup.
> > It is still OK, but I can't insert one raid layer, because the raid's
> > superblock, and the XFS is'nt shrinkable. :-(
> >
> > The only one way (I think) to plug in another raw device, and build an
array
> > from 8TB-device + new small device, to get much space to FS.
> >
> > But it is too risky for me!
>
> Yes, I wouldn't bother just for testing.  I've managed to put together
> some huge devices with spare files and multi-layer linear arrays (ext3
> won't allow files as big as 2TB) and I am happy that the patch works.
>
> Longer term, I have been thinking of enhancing mdadm so that when you
> create a linear array, it copies the few blocks from the end that will
> be over written by the superblock onto the start of the second
> device.  This would allow a single device to be extended into a linear
> array without loss.  (I also have patches to hot-add devices to the
> end of a linear array which I really should dust-off and get into
> mainline).

Yes!
This is very good idea!
I can do that manually with dd, but some people can't.
This, and sometimes reverse of this is a usefull options!

In my case:
I add some small HDD to my big array, to try the patch.
Thats ok.
But later, when I try to change the small to another big, there is no easy
way, to do this.
When I copy the small drive with dd or cat to 2nd big array, the superblock
is wrong placed.
(or not?)


> >
> > Do you think it is safe?
> >
> > Currently I use 2.6.13-rc3.
> > This patch is good for this version, or only the last version?
> >
> > Witch is the last? 2.6.13-rc6 or rc6-git7, or 2.6.14 -git cvs? :)
>
> The patch should be good against any reasonable recent version of
> 2.6.  I always work against the latest -mm, but this code has been
> largely untouched for a while so there shouldn't be any patch
> conflicts.

Thanks, I will try it!
But in the last month my system's downtime is almost more than uptime, and
now I try to fix this very bad stat. :-)


Janos

