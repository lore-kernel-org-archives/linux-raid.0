From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Fri, 16 Jun 2017 12:07:46 -0700
Message-ID: <20170616190746.s4ykbmr2tcysimta@kernel.org>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
 <877f0c7gvr.fsf@notabene.neil.brown.name>
 <20170616155204.myffyxp5tuoctcoo@kernel.org>
 <40a41d94-b930-e402-9ce4-4d4f47873e64@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40a41d94-b930-e402-9ce4-4d4f47873e64@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

On Sat, Jun 17, 2017 at 02:06:23AM +0800, Brad Campbell wrote:
> On 16/06/17 23:52, Shaohua Li wrote:
> > On Fri, Jun 16, 2017 at 01:26:00PM +1000, Neil Brown wrote:
> > > If an md device is left suspended, then the current code will block IO
> > > indefinitely.  This patch will at a 20minute times to every single
> > > request, which will mean IO proceeds, but extremely slowly.  I don't see
> > > that as a useful improvement.
> > 
> > It returns error, so application will not dispatch more IO. But I agree a
> > timeout to clear the suspend looks a better policy.
> 
> If you insist on doing this, make the default timeout configurable and set
> it to wait forever by default. That way there is no change in current
> behaviour.

That's meaningless if the default is wait forever
 
> There are a number of times I've tickled those values to suspend things
> while doing something sinister to the array. I'd be mighty upset if I got
> called away and came back to find the kernel had resumed underneath me
> because it thinks it knows best.

I'd like to know your use case, can you describe it in details? I thought only
raid6check uses this function. If there are other usage cases which depend on
current behavior, we certaily can't change it.

Thanks,
Shaohua
