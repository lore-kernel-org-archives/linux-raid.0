From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: md deadlock (was Re: 2.6.18-mm2)
Date: Fri, 29 Sep 2006 16:03:17 +0200
Message-ID: <1159538597.28131.97.camel@taijtu>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	 <6bffcb0e0609280454n34d40c0la8786e1eba6dcdf3@mail.gmail.com>
	 <1159531923.28131.80.camel@taijtu>
	 <17693.5913.393686.223172@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17693.5913.393686.223172@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-09-29 at 22:52 +1000, Neil Brown wrote:
> On Friday September 29, a.p.zijlstra@chello.nl wrote:
> > On Thu, 2006-09-28 at 13:54 +0200, Michal Piotrowski wrote:
> > 
> > Looks like a real deadlock here. It seems to me #2 is the easiest to
> > break.
> 
> I guess it could deadlock if you tried to add /dev/md0 as a component
> of /dev/md0.  I should probably check for that somewhere.
> In other cases the array->member ordering ensures there is no
> deadlock.
> 


	1					2

 open(/dev/md0)

					open(/dev/md0)
					- do_open() -> bdev->bd_mutex
 ioctl(/dev/md0, hotadd) 
 - md_ioctl() -> mddev->reconfig_mutex
 -- hot_add_disk()
 --- bind_rdev_to_array()
 ---- bd_claim_by_disk()
 ----- bd_claim_by_kobject()
					-- md_open()
					--- mddev_lock()
					---- mutex_lock(mddev->reconfig_mutex)
 ------ mutex_lock(bdev->bd_mutex)


looks like an AB-BA deadlock to me


