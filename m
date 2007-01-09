From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [patch] md: pass down BIO_RW_SYNC in raid{1,10}
Date: Tue, 9 Jan 2007 11:13:27 -0500
Message-ID: <170fa0d20701090813k66decafs909e925618993996@mail.gmail.com>
References: <20070108090833.GF8125@soda.linbit>
	 <20070108150242.1b39eda2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070108150242.1b39eda2.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Lars Ellenberg <Lars.Ellenberg@linbit.com>, Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, stable@kernel.org
List-Id: linux-raid.ids

On 1/8/07, Andrew Morton <akpm@osdl.org> wrote:
> On Mon, 8 Jan 2007 10:08:34 +0100
> Lars Ellenberg <Lars.Ellenberg@linbit.com> wrote:
>
> > md raidX make_request functions strip off the BIO_RW_SYNC flag,
> > thus introducing additional latency.
> >
> > fixing this in raid1 and raid10 seems to be straight forward enough.
> >
> > for our particular usage case in DRBD, passing this flag improved
> > some initialization time from ~5 minutes to ~5 seconds.
>
> That sounds like a significant fix.

So will this fix also improve performance associated with raid1's
internal bitmap support?  What is the scope of the performance
problems this fix will address?  That is, what are some other examples
of where users might see a benefit from this patch?

regards,
Mike
