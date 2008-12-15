From: Neil Brown <neilb@suse.de>
Subject: Re: Help recovering RAID6 failure
Date: Tue, 16 Dec 2008 10:05:19 +1100
Message-ID: <18758.58031.230346.101105@notabene.brown>
References: <20081215220307.GE1749@cubit>
	<18758.55029.597319.376426@notabene.brown>
	<20081215222522.GF1749@cubit>
	<20081215223753.GG1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kevin Shanahan on Tuesday December 16
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Shanahan <kmshanah@disenchant.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 16, kmshanah@disenchant.net wrote:
> 
> Oh, and here's what gets added to dmesg after running that command:
> 

> raid5: cannot start dirty degraded array for md5

I thought that might be the case.  --force is meant to fix that -
remove the 'dirty' flag from the array.
> 
> This is run on Linux 2.6.26.9, mdadm 2.6.7.1 (Debian)

Hmm.. and there goes that theory.  There was a bug in mdadm prior to
2.6 which caused --force not to work for raid6 with 2 drives missing.

It looks like some of your devices are marks 'clean' and some are
'active'.  mdadm is noticing one that is 'clean' and not bothering to
mark the others as 'clean'.  The kernel is seeing one that is 'active'
and complaining.

The devices that are 'active' are sd[efl]1.  Maybe if you list one of
those last it will work.
e.g.

  mdadm -A --force --verbose /dev/md5 /dev/sd[cfghijk]1 /dev/sde1

If not, try listing it first.

I'll try to fix mdadm so that it gets this right.

Thanks,
NeilBrown
