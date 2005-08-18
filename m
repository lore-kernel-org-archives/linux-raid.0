From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Found a new bug!
Date: Thu, 18 Aug 2005 14:34:55 +1000
Message-ID: <17156.4079.67097.825741@cse.unsw.edu.au>
References: <20050717182650.24540.patches@notabene>
	<E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	<009001c58ac8$9ab25d40$0400a8c0@LocalHost>
	<17114.55335.687696.686786@cse.unsw.edu.au>
	<03e501c5a120$f3a79a00$0400a8c0@LocalHost>
	<17151.60931.26972.713074@cse.unsw.edu.au>
	<011101c5a187$3bc8cf00$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Monday August 15
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 15, djani22@dynamicweb.hu wrote:
> Thanks, I will test it, when I can...
> 
> In this moment, my system is an working online system, and now only one 8TB
> space what I can use...
> Thats right, maybe I can built linear array from only one soure device,but:
> My first problem is, on my 8TB device is already exists XFS filesystem, with
> valuable data, what I can't backup.
> It is still OK, but I can't insert one raid layer, because the raid's
> superblock, and the XFS is'nt shrinkable. :-(
> 
> The only one way (I think) to plug in another raw device, and build an array
> from 8TB-device + new small device, to get much space to FS.
> 
> But it is too risky for me!

Yes, I wouldn't bother just for testing.  I've managed to put together
some huge devices with spare files and multi-layer linear arrays (ext3
won't allow files as big as 2TB) and I am happy that the patch works.

Longer term, I have been thinking of enhancing mdadm so that when you
create a linear array, it copies the few blocks from the end that will
be over written by the superblock onto the start of the second
device.  This would allow a single device to be extended into a linear
array without loss.  (I also have patches to hot-add devices to the
end of a linear array which I really should dust-off and get into
mainline). 
> 
> Do you think it is safe?
> 
> Currently I use 2.6.13-rc3.
> This patch is good for this version, or only the last version?
> 
> Witch is the last? 2.6.13-rc6 or rc6-git7, or 2.6.14 -git cvs? :)

The patch should be good against any reasonable recent version of
2.6.  I always work against the latest -mm, but this code has been
largely untouched for a while so there shouldn't be any patch
conflicts.

NeilBrown
