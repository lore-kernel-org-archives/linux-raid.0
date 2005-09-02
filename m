From: Luca Berra <bluca@comedia.it>
Subject: Re: question regarding multipath & Linux 2.6
Date: Fri, 2 Sep 2005 08:38:56 +0200
Message-ID: <20050902063856.GB8680@percy.comedia.it>
References: <Pine.LNX.4.44.0509011419390.15688-100000@netra.cs.yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0509011419390.15688-100000@netra.cs.yale.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 01, 2005 at 02:51:44PM -0400, Jim Faulkner wrote:
>
>Hello,
>
>Recently my department had a SAN installed, and I am in the process of 
>setting up one of the first Linux machines connected to it.  The machine 
>is running Red Hat Enterprise AS4 (x86_64), which uses Linux kernel 
>version 2.6.9-11.ELsmp.
giving more info about the infamous SAN would help :)
>
>The SAN shows up twice in the kernel, as /dev/sdb and /dev/sdc.  /dev/sdb 
>is inaccessible (I get a bunch of "Buffer I/O error on device sdb" kernel 
>errors), but /dev/sdc works fine.  According to the administrator of the 
it probably is a cheapo storage with an Active/Passive storage
controller, you cannot use md to handle those.

>He told me to use PowerPath, but I'd rather not have to reinstall or 
it is a long time i don't see powerpath on linux, but i am in favour of
ditching proprietary multipath solutions in favour of free ones.
>
what you want is multipath-tools http://christophe.varoqui.free.fr/
RH4 should already include a multipath-tools rpm.

Regards,
Luca

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
