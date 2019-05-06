From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] md: properly lock and unlock in rdev_attr_store()
Date: Mon, 6 May 2019 07:03:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1905060657010.2480@felia>
References: <20190428104041.11262-1-lukas.bulwahn@gmail.com> <877ebd693t.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877ebd693t.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>, Shaohua Li <shli@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Himanshu Jha <himanshujha199639@gmail.com>, clang-built-linux@googlegroups.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 29 Apr 2019, NeilBrown wrote:

> On Sun, Apr 28 2019, Lukas Bulwahn wrote:
> 
> > rdev_attr_store() should lock and unlock mddev->reconfig_mutex in a
> > balanced way with mddev_lock() and mddev_unlock().
> 
> It does.
> 
> >
> > But when rdev->mddev is NULL, rdev_attr_store() would try to unlock
> > without locking before. Resolve this locking issue..
> 
> This is incorrect.
> 
> >
> > This locking issue was detected with Clang Thread Safety Analyser:
> 
> Either the Clang Thread Safety Analyser is broken, or you used it
> incorrectly.
>

Please ignore this patch.

Clang Thread Safety Analyser cannot handle the original code, but can
handle my semantically equivalent code. I did not get that at first, and
thought I fixed an issue, but I did not.

Sorry for the noise.

Lukas
 
> >
> > drivers/md/md.c:3393:3: warning: releasing mutex 'mddev->reconfig_mutex' that was not held [-Wthread-safety-analysis]
> >                 mddev_unlock(mddev);
> >                 ^
> >
> > This warning was reported after annotating mutex functions and
> > mddev_lock() and mddev_unlock().
> >
> > Fixes: 27c529bb8e90 ("md: lock access to rdev attributes properly")
> > Link: https://groups.google.com/d/topic/clang-built-linux/CvBiiQLB0H4/discussion
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > Arnd, Neil, here a proposal to fix lock and unlocking asymmetry.
> >
> > I quite sure that if mddev is NULL, it should just return.
> 
> If mddev is NULL, the code does return (with -EBUSY).  All you've done
> is change things so it returns from a different part of the code.  You
> haven't changed the behaviour at all.
> 
> >
> > I am still puzzled if the return value from mddev_lock() should be really
> > return by rdev_attr_store() when it is not 0. But that was the behaviour
> > before, so I will keep it that way.
> 
> Certainly it should. mddev_lock() either returns 0 to indicate success
> or -EINTR if it received a signal.
> If it was interrupted by a signal, then rdev_attr_store() should return
> -EINTR as well.
> 
> As Arnd tried to explain, the only possible problem here is that the C
> compiler is allowed to assume that rdev->mddev never changes value, so
> in
>    rv = mddev ? mddev_lock(mddev) : =EBUSY
> 
> it could load rdev->mddev, test if it is NULL, then load it again and
> pass that value to mddev_lock() - the new value might be NULL which
> would cause problems.
> 
> This could be fixed by changing
> 
> 	struct mddev *mddev = rdev->mddev;
> to
> 	struct mddev *mddev = READ_ONCE(rdev->mddev);
> 
> That is the only change that might be useful here.
> 
> NeilBrown
> 
> 
> >
> >  drivers/md/md.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 05ffffb8b769..a9735d8f1e70 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3384,7 +3384,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
> >  		return -EIO;
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EACCES;
> > -	rv = mddev ? mddev_lock(mddev): -EBUSY;
> > +	if (!mddev)
> > +		return -EBUSY;
> > +	rv = mddev_lock(mddev);
> >  	if (!rv) {
> >  		if (rdev->mddev == NULL)
> >  			rv = -EBUSY;
> > -- 
> > 2.17.1
> 
