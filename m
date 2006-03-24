From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm shutdown question
Date: Fri, 24 Mar 2006 11:55:19 +1100
Message-ID: <17443.17271.91625.522918@cse.unsw.edu.au>
References: <20060323144235.GC25807@timor.isp-services.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Frido Ferdinand on Thursday March 23
Sender: linux-raid-owner@vger.kernel.org
To: Frido Ferdinand <frido@zolder.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 23, frido@zolder.org wrote:
> Hi,
> 
> This question is mainly about the following error during shutdown on my 
> gentoo system:
> 
> mdadm: fail to stop array /dev/md1: Device or resource busy
> 
> (full raid1, root is on /dev/md1)
> 
> After searching bugzilla I found:
> 
> http://bugs.gentoo.org/show_bug.cgi?id=119380
> 
> However there's no agreement on if / how mdadm should stop the rootfs 
> during a shutdown sequence. Can anyone enlight me on a good way to
> proceed in this ?

There is no need to stop the root md, or in fact any md, at shutdown.
The shutdown process in the kernel will switch any active md arrays to
read-only, which is effectively the same as shutting them down.

It doesn't hurt to do
  mdadm -Ss
but it isn't really needed and you can ignore any errors.

NeilBrown

> 
> Regards,
> 
> 		-- Frido Ferdinand
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
