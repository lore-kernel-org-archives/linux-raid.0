From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md.c Kernel BUG(?) and reboot segfault
Date: Mon, 28 Oct 2002 09:56:22 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15804.28438.676002.891659@notabene.cse.unsw.edu.au>
References: <200210241315.g9ODFKGV028540@pcrz175.hrz.uni-marburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Gebhardt on Thursday October 24
To: Thomas Gebhardt <gebhardt@HRZ.Uni-Marburg.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 24, gebhardt@HRZ.Uni-Marburg.DE wrote:
> Hi,
> 
> just tried to configure rootfs Software-RAID1 on a Debian Woody
> (SMP-Kernel 2.4.19 with some of the jp Patches applied). When I reboot
> the machine, the final reboot command in /etc/init.d/reboot
> segfaults after the following error messages:
> 
> md: stopping all md devices
> invalidate; busy buffer
> ...
> md: marking sb clean
> kernel BUG at md.c:1251!

Line 1251 of md.c in 2.4.19 doesn't have a 'BUG' sop the 'jp Patches'
must have moved things around.  Maybe if you could send me a copy of
you md.c.....

NeilBrown

> invalid operand: 0000
> CPU:  1
> EIP:  0010: [<c02080a2>]   Not tainted
> EFLAGS:  00010202
> ...
> Segmentation fault
> 
> A second reboot command succeeds. So, as a workaround, I duplicated
> the reboot command in /etc/init.d/reboot in order to shut the
> system down without manual interaction.
> 
> Any hints what to do?
> 
> Thank you for your advice!
> Cheers, Thomas
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
