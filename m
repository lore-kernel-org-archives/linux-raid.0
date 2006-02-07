From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid 1 always degrades after a reboot.
Date: Tue, 7 Feb 2006 11:52:25 +0100
Message-ID: <20060207105225.GE22221@percy.comedia.it>
References: <001b01c62b72$3128a050$f400a8c0@tweety>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001b01c62b72$3128a050$f400a8c0@tweety>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 06, 2006 at 03:08:07PM -0800, Hans Rasmussen wrote:
>Hi all.
>
>After every reboot, my brand new Raid1 array comes up degraded.  It's 
>always /dev/sdb1 that is unavailable or removed.
...
>Mandriva 2006 download edition, upgraded from Mandrake 9.1
>Kernel 2.6.12-15mdk (not rebuilt)
>MDADM version 00.90.01
this is the version of the md driver in the kernel, mdadm on 2006 is
1.12.0

could you please check if the array is stopped correctly at shutdown
maybe temporarily removing the splash thing from lilo/grub will allow
you to see more clearly.
Q. does the SATA300 TX2Plus card support fakeraid?
in case it does and it is enable that could conflict with md.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
