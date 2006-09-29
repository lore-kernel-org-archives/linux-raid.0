From: Neil Brown <neilb@suse.de>
Subject: Re: md deadlock (was Re: 2.6.18-mm2)
Date: Fri, 29 Sep 2006 22:52:41 +1000
Message-ID: <17693.5913.393686.223172@cse.unsw.edu.au>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	<6bffcb0e0609280454n34d40c0la8786e1eba6dcdf3@mail.gmail.com>
	<1159531923.28131.80.camel@taijtu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Zijlstra on Friday September 29
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 29, a.p.zijlstra@chello.nl wrote:
> On Thu, 2006-09-28 at 13:54 +0200, Michal Piotrowski wrote:
> 
> Looks like a real deadlock here. It seems to me #2 is the easiest to
> break.

I guess it could deadlock if you tried to add /dev/md0 as a component
of /dev/md0.  I should probably check for that somewhere.
In other cases the array->member ordering ensures there is no
deadlock.

> 
> static int md_open(struct inode *inode, struct file *file)
> {
> 	/*
> 	 * Succeed if we can lock the mddev, which confirms that
> 	 * it isn't being stopped right now.
> 	 */
> 	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
> 	int err;
> 
> 	if ((err = mddev_lock(mddev)))
> 		goto out;
> 
> 	err = 0;
> 	mddev_get(mddev);
> 	mddev_unlock(mddev);
> 
> 	check_disk_change(inode->i_bdev);
>  out:
> 	return err;
> }
> 
> mddev_get() is a simple atomic_inc(), and I fail to see how waiting for
> the lock makes any difference.

Hmm... I"m pretty sure I do want some sort of locking there - to make
sure that the
		if (atomic_read(&mddev->active)>2) {
test in do_md_stop actually means something.  However it does seem
that the locking I have doesn't really guarantee anything much.

But I really think that this locking order should be allowed.  md
should ensure that there are never any loops in the array->member
ordering, and somehow that needs to be communicated to lockdep.

One of the items on my todo list is to sort out the lifetime rules of
md devices (once accessed, they currently never disappear).  Getting
this locking right should be part of that.

NeilBrown
