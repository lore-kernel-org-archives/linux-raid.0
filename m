From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH] raid5-ppl: PPL support for disks with write-back cache
 enabled
Date: Thu, 21 Dec 2017 10:19:02 +0100
Message-ID: <20171221091902.GA26533@proton.igk.intel.com>
References: <1513604700-1826-1-git-send-email-tomasz.majchrzak@intel.com>
 <201712210051.48XorsHT%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201712210051.48XorsHT%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

On Thu, Dec 21, 2017 at 12:35:21AM +0800, kbuild test robot wrote:
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v4.15-rc4 next-20171220]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Tomasz-Majchrzak/raid5-ppl-PPL-support-for-disks-with-write-back-cache-enabled/20171220-181528
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
>    633	
>    634			rcu_read_lock();
>  > 635			rdev = rcu_dereference(conf->disks[i].rdev);
>    636			if (rdev && test_bit(Faulty, &rdev->flags))
>    637				rdev = NULL;
>    638			rcu_read_unlock();

The warning from sparse is:

drivers/md/raid5-ppl.c:635:24: error: incompatible types in comparison expression (different address spaces)

There is the same warning for 20 other places in md raid5 code, everywhere
where rcu_dereference is used so I understand the probles is either in sparse
or in function implementation.

Tomek
