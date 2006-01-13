From: Adrian Bunk <bunk@stusta.de>
Subject: Re: powerpc: raid6 (raid6int8) compilation error
Date: Fri, 13 Jan 2006 12:17:53 +0100
Message-ID: <20060113111753.GF29663@stusta.de>
References: <20060110202831.GA10837@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060110202831.GA10837@sergelap.austin.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mingo@redhat.com, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

On Tue, Jan 10, 2006 at 02:28:31PM -0600, Serge E. Hallyn wrote:
> Since 2.6.15-rc6, and continuing through 2.6.15-mm2, I get the following
> error when compiling a kernel with gcc 3.4.4 on a power5 with RHEL4U1
> installed and uptodate:
> 
> drivers/md/raid6int8.c: In function `raid6_int8_gen_syndrome':
> drivers/md/raid6int8.c:185: error: unable to find a register to spill in
> class `FLOAT_REGS'
> drivers/md/raid6int8.c:185: error: this is the insn:
> (insn:HI 619 621 640 4 (set (mem:DI (plus:DI (reg/v/f:DI 122 [ p ])
>                 (reg/v:DI 66 ctr [orig:124 d ] [124])) [0 S8 A64])
>         (reg/v:DI 129 [ wp0 ])) 320 {*movdi_internal64} (nil)
> 	    (expr_list:REG_DEAD (reg/v:DI 129 [ wp0 ])
> 	            (nil)))
> drivers/md/raid6int8.c:185: confused by earlier errors, bailing out
>   CC [M]  drivers/md/raid6altivec4.o
> 
> 2.6.14-rc5 does not give this error...
>...

This is an internal error in gcc.
You should report this as a bug in gcc to RedHat.

> thanks,
> -serge

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

