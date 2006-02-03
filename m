From: dean gaudet <dean@arctic.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Thu, 2 Feb 2006 18:13:54 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0602021808100.6557@twinlark.arctic.org>
References: <200602031229.37972.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200602031229.37972.mylists@blue-matrix.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lewis Shobbrook <mylists@blue-matrix.org>
Cc: linux-raid@vger.kernel.org, dr@jones.dk
List-Id: linux-raid.ids

i've never looked at yaird in detail -- but you can probably use 
initramfs-tools instead of yaird... the deb 2.6.14 and later kernels will 
use whichever one of those is installed.  i know that initramfs-tools uses 
mdrun to start the root partition based on its UUID -- and so it should 
work fine (to get root mounted) even without dorking around with 
mdadm.conf.

but if you want to stick with yaird:

On Fri, 3 Feb 2006, Lewis Shobbrook wrote:

> My mdadm.conf (I never needed to use at all previous to the yaird system) is
> as follows...
> ARRAY /dev/md0 level=raid1 num-devices=3 devices=/dev/sda2,/dev/sdb2,/dev/sdc2
> auto=yes
> ARRAY /dev/md1 level=raid5 num-devices=3 auto=yes
> UUID=a3452240:a1578a31:737679af:58f53690
> DEVICE partitions

some wrapping occured there i'm guessing...

you might be a lot happier if your /dev/md0 also specified the UUID rather 
than the individual devices.  this is probably the source of your 
troubles.

you can get the UUID by doing "mdadm --examine /dev/sda2".

or you can try:  mdadm --examine --scan --brief ... just prepend "DEVICE 
partitions" in front of that and you should be happy.

-dean
