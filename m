From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Wed, 24 Oct 2007 17:03:50 -0700 (PDT)
Message-ID: <20071024.170350.195077498.davem@davemloft.net>
References: <4719B6DE.9040403@systella.fr>
	<471EF07A.5040007@systella.fr>
	<e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: joel.bertrand@systella.fr, davidsen@tmr.com, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, blackmagic02881@gmail.com
List-Id: linux-raid.ids

From: "Dan Williams" <dan.j.williams@intel.com>
Date: Wed, 24 Oct 2007 16:49:28 -0700

> Hopefully it is as painless to run on sparc as it is on IA:
> 
> opcontrol --start --vmlinux=/path/to/vmlinux
> <wait>
> opcontrol --stop
> opreport --image-path=/lib/modules/`uname -r` -l

It is painless, I use it all the time.

The only caveat is to make sure the /path/to/vmlinux is
the pre-stripped kernel image.  The images installed
under /boot/ are usually stripped and thus not suitable
for profiling.
