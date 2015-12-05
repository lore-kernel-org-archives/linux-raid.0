From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Fri, 4 Dec 2015 19:38:35 -0600
Message-ID: <CAE9DZUTp_YZX2mx5DEjvkcncs9KQzw_+xP1EtqD0we6LQ5eVUg@mail.gmail.com>
References: <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
	<565F03F2.3070803@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
	<565F1035.10800@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
	<565F136F.2090709@turmel.org>
	<CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
	<F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
	<566059E8.60804@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
	<20151204185155.GA3590@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151204185155.GA3590@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Robert Kierski <rkierski@cray.com>, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 4, 2015 at 12:51 PM, Shaohua Li <shli@kernel.org> wrote:
> On Fri, Dec 04, 2015 at 01:40:02PM +0000, Robert Kierski wrote:
>> It turns out the problem I'm experiencing is related to thread count.  When I run XDD with a reasonable queuedepth parameter (32), I get horrible performance.  When I run it with a small queuedepth (1-4), I get expected performance.
>>
>> Here are the command lines:
>>
>> Horrible Performance:
>> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 32  -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>>
>> GOOD Performance:
>> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 1 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>>
>> BEST Performance:
>> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 3 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>>
>> BAD Performance
>> xdd -id commandline -dio -maxall -targets 1 /dev/md1 -queuedepth 5 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>
> the performance issue only happens for directIO write, right? did you check
> buffered write? The directIO case doesn't delay write, so will create more
> read-modify-write. you can check with below debug code.
>
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 45933c1..d480cc3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5278,10 +5278,10 @@ static void make_request(struct mddev *mddev, struct bio * bi)
>                         }
>                         set_bit(STRIPE_HANDLE, &sh->state);
>                         clear_bit(STRIPE_DELAYED, &sh->state);
> -                       if ((!sh->batch_head || sh == sh->batch_head) &&
> -                           (bi->bi_rw & REQ_SYNC) &&
> -                           !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -                               atomic_inc(&conf->preread_active_stripes);
> +//                     if ((!sh->batch_head || sh == sh->batch_head) &&
> +//                         (bi->bi_rw & REQ_SYNC) &&
> +//                         !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +//                             atomic_inc(&conf->preread_active_stripes);
>                         release_stripe_plug(mddev, sh);
>                 } else {
>                         /* cannot get stripe for read-ahead, just give-up */

Hi all.  My original test involved fio sequential writing to XFS
formatted RAID devices with block size = 2M and queue depth = 256.
Today I spent some time focused on testing raw RAID sequential write
tests with dd similar to Robert's tests.  I am happy to report that I
see the exact opposite results that I reported earlier with fio / XFS.
When comparing performance between the 2.6.39.4 kernel and the 3.10.69
kernel, I am seeing that RAID 0 and and RAID 1 write speeds are about
the same.  However, RAID 5 is about 60% faster in the 3.10.69 kernel
and RAID 6 is 40% faster.  I am not sure how to control queue depth
with plain old dd.

Next I am going to get a second opinion from fio, this time writing
directly to the RAID devices instead of going through XFS with varying
queue depth.  If I see the same behavior as with DD, then there is no
problem with RAID in the new kernels - it is something else, perhaps
XFS.  Will report my fio findings as soon as I have a chance to
capture them.
