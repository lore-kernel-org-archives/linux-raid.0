From: Neil Brown <neilb@suse.de>
Subject: Re: Problem regarding RAID10 on kernel 2.6.31
Date: Mon, 9 Aug 2010 18:10:42 +1000
Message-ID: <20100809181042.2dd7f7ca@notabene>
References: <1281087718.14259.5.camel@venkata-pc.in.caveonetworks.com>
	<20100806201435.5a3cb1f9@notabene>
	<1281339596.18581.34.camel@venkata-pc.in.caveonetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281339596.18581.34.camel@venkata-pc.in.caveonetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: ravichandra <vmynidi@caviumnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 09 Aug 2010 13:09:56 +0530
ravichandra <vmynidi@caviumnetworks.com> wrote:

> Hi,
>    Thanks.The patch you have sent is working.There is no hanging up
> after the patch is applied.can you elaborate on the problem which was
> there earlier??
> 

It's .... complicated.

An important fact is that generic_make_request queues recursive requests
rather than issuing them immediately.  This avoids excessive stack usage with
stacked block devices.

So in the case where a read crosses a chunk boundary, raid10:make_request
issues two separate generic_make_request calls to two different devices, each
preceded by a wait_barrier call (Which is cancelled with allow_barrer() when
the request completes).
The first is queued and will not be issued until the second is also queued and
the raid10:make_request call completes.

The wait_barrier call increments nr_pending.
If the resync/recovery thread tries to 'raise_barrier' between these calls,
it will find nr_pending set and will wait with ->barrier incremented so when
the next wait_barrier is attempted, is will block - forever.

If generic_make_request didn't queue things, the first request would
complete, nr_pending would decrement, resync would proceed with a single
request, then the second wait_barrier would complete and the second request
could be submitted.

The fix was to elevate conf->nr_waiting for the duration of both submissions
so raise_barrier holds off setting ->barrier until both submissions are
complete.

Hope that makes sense.

NeilBrown

