From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.0: segfault. known issue?
Date: Fri, 25 Sep 2009 14:08:23 +1000
Message-ID: <19132.16951.956944.319780@notabene.brown>
References: <cccedfc60909211213q2b0d595cmd721264b1e843da4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday September 21
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday September 21, jnelson-linux-raid@jamponi.net wrote:
> On one machine I have, mdadm (3.0) segfaults every time the machine is booted.
> After boot, the same commandline appears to work just fine.
> 
> >From the boot messages:
> 
> <6>mdadm[1815]: segfault at 5c ip 000000000041f2b3 sp 00007fffb3b62c80
> error 4 in mdadm[400000+40000]
> 
> and more:
> 
> Starting MD Raid mdadm: /dev/md/turnip:12 has been started with 1
> drive (out of 2).
> /etc/init.d/boot.d/S07boot.md: line 97:  1815 Segmentation fault
> $mdadm_BIN -A -s -c $mdadm_CONFIG
> failed

Hard to know without more details.
Is this the OpenSUSE 11.1 mdadm, or one that you have compiled
yourself?
If you

   gdb `which mdadm`
   x/20i 0x000000000041f2b3

does it show anything interesting?

Knowing the contents of $mdadm_CONFIG and the result of
  mdadm -Es

might help too.

NeilBrown
