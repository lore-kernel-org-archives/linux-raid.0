From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Fri, 22 Feb 2013 09:03:23 -0700
Message-ID: <1361549003.4863.58.camel@linux-lxtg.site>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	 <51275BF6.2050702@gmail.com>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51275BF6.2050702@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <kedacomkernel@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Fri, 2013-02-22 at 19:52 +0800, majianpeng wrote:

> > Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Attempting to freeze array: barrier (1), nr_waiting (1), nr_pending (5), nr_queued (3)
> > Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (2), nr_pending (5), nr_queued (3)
> > Feb 20 17:47:38 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (3), nr_pending (5), nr_queued (3)
> From those message,there's a request which will be completed or met error.
> If completed, the ->nr_pening decrease one.
> If request met error, it add ->retry_list and the ->nr_queued add one.
> So in two conditions,the hung will be happened.
> What's the state of this request? Maybe this bug caused by lower layer drivers.

That's a good question.  Do you have any suggestion as to how I might
answer it?  As I say, I can readily reproduce it so if you have some
insight into how to capture that info I can do it with no problem.

Also, I don't know for sure but it didn't sound like Joe Lawrence is
using the same lower layer drivers but he has the same problem.

Tregaron

