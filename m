From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: Still Need Help on mdadm and udev
Date: Thu, 10 Nov 2005 14:29:05 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0511101421260.19226-100000@firewall2.tmr.com>
References: <17266.60719.545745.800152@cse.unsw.edu.au>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17266.60719.545745.800152@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: andyliebman@editshare.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Nov 2005, Neil Brown wrote:

>  From 'man mdadm'
> 
>        -a, --auto{=no,yes,md,mdp,part,p}{NN}
>               Instruct mdadm to create the device file if needed, possibly allocat-
>               ing an unused minor number.  "md" causes a non-partitionable array to
>               be  used.  "mdp", "part" or "p" causes a partitionable array (2.6 and
>               later) to be used.  "yes" requires the named md device to have a from
>               this.  See DEVICE NAMES below.
> 
> Hmmm. there is some text missing there.  It should read:
> 
>        -a, --auto{=no,yes,md,mdp,part,p}{NN}
>               Instruct  mdadm  to  create  the device file if needed, possibly
>               allocating an unused minor number.  "md" causes a non-partition-
>               able array to be used.  "mdp", "part" or "p" causes a partition-
>               able array (2.6 and later) to be used.  "yes" requires the named
>               md  device  to  have a 'standard' format, and the type and minor
>               number will be determined from this.  See DEVICE NAMES below.
> 
> (typo in the mdadm.8 source file).

Oh good, I though I was going senile... I haven't had a good use for a 
partitionable device, although I can think of some unusual applications 
for this, such as creating two RAID-6 partitionable arrarys on separate 
controllers, then combining a partition from each as RAID-1 for even more
reliability, and doubg RAID-0 over another two to spread head motion for a 
very active application.

Yes, I know there are other ways to do that, it was an example...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

