From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1785 while trying to issue a discard to
 LVM on RAID1 md
Date: Thu, 6 Oct 2016 07:57:59 +0100
Message-ID: <CALjAwxjRVs0ozLwe-avrure85+y4Ajg-KNf2a7a__jfsL2BspQ@mail.gmail.com>
References: <CALjAwxgg-m2bgFf10hLB3j=2ntVxqt0vDSKuQyOavqvKXC2G5Q@mail.gmail.com>
 <CALjAwxhYh0JDKh7E_t9sm-vBBPX-3dzL5hDMi4rA6uE2RqaJoQ@mail.gmail.com> <20161005213945.GA84123@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161005213945.GA84123@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 5 October 2016 at 22:39, Shaohua Li <shli@kernel.org> wrote:
> On Wed, Oct 05, 2016 at 10:31:11PM +0100, Sitsofe Wheeler wrote:
>> On 3 October 2016 at 17:47, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> >
>> > While trying to do a discard (via blkdiscard --length 1048576
>> > /dev/<pathtodevice>) to an LVM device atop a two disk md RAID1 the
>> > following oops was generated:
>> >
>> > [  103.306243] md: resync of RAID array md127
>> > [  103.306246] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> > [  103.306248] md: using maximum available idle IO bandwidth (but not
>> > more than 200000 KB/sec) for resync.
>> > [  103.306251] md: using 128k window, over a total of 244194432k.
>> > [  103.308158] ------------[ cut here ]------------
>> > [  103.308205] kernel BUG at block/bio.c:1785!
>>
>> This still seems to be here but slightly modified with a 4.8.0 kernel:
>
> Does this fix the issue? Looks there is IO error
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 21dc00e..349eb11 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2196,7 +2196,6 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
>                         wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
>                 }
>
> -               bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
>                 wbio->bi_iter.bi_sector = r1_bio->sector;
>                 wbio->bi_iter.bi_size = r1_bio->sectors << 9;
>

Yes the patch above fixes the issue and make blkdiscard just report
that the BLKDISCARD ioctl failed. Since having this patch applied
means the issue seen in
http://www.gossamer-threads.com/lists/linux/kernel/2538757?do=post_view_threaded#2538757
(BUG at arch/x86/kernel/pci-nommu.c:66 / BUG at
./include/linux/scatterlist.h:90) can't be reached does that mean
whatever was seen there is also spurious?

Additionally as this issue seems to have been a problem going back to
at least the 3.18 kernels, would a fix similar to this be eligible for
stable kernels?

-- 
Sitsofe | http://sucs.org/~sits/
