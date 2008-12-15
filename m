From: Neil Brown <neilb@suse.de>
Subject: Re: behavior different from mdadm 2.6.4 and 3.0?
Date: Tue, 16 Dec 2008 08:11:50 +1100
Message-ID: <18758.51222.370545.686154@notabene.brown>
References: <cccedfc60812150654u2e841bf8na517a75820d0c463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> mdadm --incremental seems to behave differently for me between mdadm
> 2.6.4 and 3.0
> 
> With 2.6.4, mdadm --incremental /dev/nbd0 does this:
> 
> mdadm: /dev/nbd0 attached to /dev/md10 which is already active.
> 
> With 3.0, it does this:
> 
> mdadm: /dev/md10 is already in use.
> 
> and does *not* add it to the array.

Sounds like /var/run/mdadm/map is not correctly up-to-date.
Does running
   mdadm -Ir

make "mdadm -I /dev/nbd0" work properly again?

Can you provide a sequence of steps which leads to the error message
that you report?

Thanks,
NeilBrown
