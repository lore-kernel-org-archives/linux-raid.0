From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/8] block/genhd.c: Add error handling
Date: Tue, 10 Nov 2015 09:11:27 -0500
Message-ID: <x49mvumlzao.fsf@segfault.boston.devel.redhat.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
	<1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
	<20151110033322.GB22011@ZenIV.linux.org.uk>
	<5641674A.6080707@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <5641674A.6080707@kernel.dk> (Jens Axboe's message of "Mon, 9 Nov
	2015 20:40:58 -0700")
Sender: linux-mmc-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com
List-Id: linux-raid.ids

Jens Axboe <axboe@kernel.dk> writes:

> On 11/09/2015 08:33 PM, Al Viro wrote:
>> On Fri, Nov 06, 2015 at 05:52:08PM +0530, Vishnu Pratap Singh wrote:
>>
>> Have you even tried to trigger the failure exits you've added?  The
>> more you've successfully set up, the _less_ your cleanup code ends
>> up undoing; that simply can't be right.
>>
>> That aside, as soon as we'd done register_disk(), the damn thing is
>> available for open(), so bailing out is _really_ not something for
>> faint-hearted - it's essentially equivalent to removal of device under
>> somebody who'd opened it and might've started IO, etc.  Going there
>> simply because some sysfs shite didn't get created doesn't look sane
>> as far as I'm concerned...
>>
>> Especially since these failure exits are not going to be tested on
>> a regular basis, so the amount of bitrot will be pretty high ;-/
>
> I'd greatly prefer it we just leave it alone. Much better to have a
> disk that does actually work and with some sysfs spew in the logs,
> than bail out for fairly vague reasons.
>
> The road to hell is paved with good intentions. It's a noble thought
> to want to clean this up, but I think it does more harm than good.

That's my fault, I asked Vishnu to repost.  I had also asked whether he
had seen this in the real world, and this was the response:

  Actually while working with zram I found that during zram
  initialization it uses the add_disk function and during that time i
  have seen sometimes under low mem condition when we enable swap (zram)
  there was kzalloc fail to allocate he memory, since there is no error
  handling it took good amount of time to debug.

Cheers,
Jeff
