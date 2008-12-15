From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Help recovering RAID6 failure
Date: Tue, 16 Dec 2008 09:48:08 +1030
Message-ID: <20081215231808.GI1749@cubit>
References: <20081215220307.GE1749@cubit> <18758.55029.597319.376426@notabene.brown> <20081215222522.GF1749@cubit> <20081215223753.GG1749@cubit> <18758.58031.230346.101105@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18758.58031.230346.101105@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 10:05:19AM +1100, Neil Brown wrote:
> On Tuesday December 16, kmshanah@disenchant.net wrote:
> > 
> > Oh, and here's what gets added to dmesg after running that command:
> > 
> 
> > raid5: cannot start dirty degraded array for md5
> 
> I thought that might be the case.  --force is meant to fix that -
> remove the 'dirty' flag from the array.
> > 
> > This is run on Linux 2.6.26.9, mdadm 2.6.7.1 (Debian)
> 
> Hmm.. and there goes that theory.  There was a bug in mdadm prior to
> 2.6 which caused --force not to work for raid6 with 2 drives missing.
> 
> It looks like some of your devices are marks 'clean' and some are
> 'active'.  mdadm is noticing one that is 'clean' and not bothering to
> mark the others as 'clean'.  The kernel is seeing one that is 'active'
> and complaining.
> 
> The devices that are 'active' are sd[efl]1.  Maybe if you list one of
> those last it will work.
> e.g.
> 
>   mdadm -A --force --verbose /dev/md5 /dev/sd[cfghijk]1 /dev/sde1
> 
> If not, try listing it first.

Aha, you're a life saver Neil:

hermes:~# mdadm -A --force --verbose /dev/md5 /dev/sd[cfghijk]1 /dev/sde1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 0.
mdadm: added /dev/sdf1 to /dev/md5 as 1
mdadm: added /dev/sdg1 to /dev/md5 as 2
mdadm: added /dev/sdk1 to /dev/md5 as 3
mdadm: added /dev/sdj1 to /dev/md5 as 4
mdadm: added /dev/sdi1 to /dev/md5 as 5
mdadm: added /dev/sdh1 to /dev/md5 as 6
mdadm: no uptodate device for slot 7 of /dev/md5
mdadm: added /dev/sdc1 to /dev/md5 as 8
mdadm: no uptodate device for slot 9 of /dev/md5
mdadm: added /dev/sde1 to /dev/md5 as 0
mdadm: failed to RUN_ARRAY /dev/md5: Input/output error
hermes:~# mdadm -S /dev/md5
mdadm: stopped /dev/md5
hermes:~# mdadm -A --force --verbose /dev/md5 /dev/sde1 /dev/sd[cfghijk]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 3.
mdadm: added /dev/sdf1 to /dev/md5 as 1
mdadm: added /dev/sdg1 to /dev/md5 as 2
mdadm: added /dev/sdk1 to /dev/md5 as 3
mdadm: added /dev/sdj1 to /dev/md5 as 4
mdadm: added /dev/sdi1 to /dev/md5 as 5
mdadm: added /dev/sdh1 to /dev/md5 as 6
mdadm: no uptodate device for slot 7 of /dev/md5
mdadm: added /dev/sdc1 to /dev/md5 as 8
mdadm: no uptodate device for slot 9 of /dev/md5
mdadm: added /dev/sde1 to /dev/md5 as 0
mdadm: /dev/md5 has been started with 8 drives (out of 10).

Now to check my data is still okay.

> I'll try to fix mdadm so that it gets this right.

Cool - glad it wasn't just a lack of coffee on my part ;)

Cheers,
Kevin.
