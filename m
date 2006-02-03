From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Fri, 3 Feb 2006 13:14:17 +1100
Message-ID: <200602031314.17919.mylists@blue-matrix.org>
References: <200602031229.37972.mylists@blue-matrix.org> <Pine.LNX.4.64.0602021808100.6557@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0602021808100.6557@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 03 February 2006 1:13 pm, you wrote:
Thanks Dean,

I'll try this out...
> i've never looked at yaird in detail -- but you can probably use
> initramfs-tools instead of yaird... the deb 2.6.14 and later kernels will
> use whichever one of those is installed.  i know that initramfs-tools uses
> mdrun to start the root partition based on its UUID -- and so it should
> work fine (to get root mounted) even without dorking around with
> mdadm.conf.
>
> but if you want to stick with yaird:
>
> On Fri, 3 Feb 2006, Lewis Shobbrook wrote:
> > My mdadm.conf (I never needed to use at all previous to the yaird system)
> > is as follows...
> > ARRAY /dev/md0 level=raid1 num-devices=3
> > devices=/dev/sda2,/dev/sdb2,/dev/sdc2 auto=yes
> > ARRAY /dev/md1 level=raid5 num-devices=3 auto=yes
> > UUID=a3452240:a1578a31:737679af:58f53690
> > DEVICE partitions
>
> some wrapping occured there i'm guessing...
>
> you might be a lot happier if your /dev/md0 also specified the UUID rather
> than the individual devices.  this is probably the source of your
> troubles.
Seems a bit confusing  and fickle of yaird that all md devices must follow the 
uuid syntax in mdadm,conf.

How do you expect that this would effect the detection of /dev/md1, where all 
the uuid on all components are intact, and /dev/md0 has the 'non-uuid' 
syntax?

When yaird first arrived (did not specifically install it just a 
dist-upgrade), I had initial problems with the boot sequence where the 
root /dev/md0 wasn't starting, despite being able to manually start it from 
the recovery console. Specifying the devices in mdadm.conf was the initial 
fix.  I'd never found the need to use mdadm.conf at all previously. 

I can't really try this til I get home, if the machine doesn't come back up my 
wife will have no MythTV playschool episodes for the rugrats.
I'll let you know how it goes.

Cheers,

Lewis
