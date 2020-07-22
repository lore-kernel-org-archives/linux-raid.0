From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH V1 3/3] improve raid10 discard request
Date: Wed, 22 Jul 2020 10:43:54 +0800
Message-ID: <ba53df52-4e87-c18d-845b-1fd95cb95176@redhat.com>
References: <1595221108-10137-1-git-send-email-xni@redhat.com>
 <1595221108-10137-4-git-send-email-xni@redhat.com>
 <ead4cd95-3a17-7ab6-3494-d1ac6bcc4d1f@suse.de>
 <f1aae07b-bdec-82ec-51a3-85de4b7e695c@suse.de>
 <CAPhsuW7=zvCANj6YcQciPHpAohOpv-XQ=eMBHrcBUmdoEBZ9yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7=zvCANj6YcQciPHpAohOpv-XQ=eMBHrcBUmdoEBZ9yw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Coly Li <colyli@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids



On 07/22/2020 08:17 AM, Song Liu wrote:
> On Sun, Jul 19, 2020 at 10:38 PM Coly Li <colyli@suse.de> wrote:
>> On 2020/7/20 13:26, Coly Li wrote:
>>> On 2020/7/20 12:58, Xiao Ni wrote:
>>>> Now the discard request is split by chunk size. So it takes a long time to finish mkfs on
>>>> disks which support discard function. This patch improve handling raid10 discard request.
>>>> It uses  the similar way with raid0(29efc390b).
>>>>
>>>> But it's a little complex than raid0. Because raid10 has different layout. If raid10 is
>>>> offset layout and the discard request is smaller than stripe size. There are some holes
>>>> when we submit discard bio to underlayer disks.
>>>>
>>>> For example: five disks (disk1 - disk5)
>>>> D01 D02 D03 D04 D05
>>>> D05 D01 D02 D03 D04
>>>> D06 D07 D08 D09 D10
>>>> D10 D06 D07 D08 D09
>>>> The discard bio just wants to discard from D03 to D10. For disk3, there is a hole between
>>>> D03 and D08. For disk4, there is a hole between D04 and D09. D03 is a chunk, raid10_write_request
>>>> can handle one chunk perfectly. So the part that is not aligned with stripe size is still
>>>> handled by raid10_write_request.
>>>>
>>>> If reshape is running when discard bio comes and the discard bio spans the reshape position,
>>>> raid10_write_request is responsible to handle this discard bio.
>>>>
>>>> I did a test with this patch set.
>>>> Without patch:
>>>> time mkfs.xfs /dev/md0
>>>> real4m39.775s
>>>> user0m0.000s
>>>> sys0m0.298s
>>>>
>>>> With patch:
>>>> time mkfs.xfs /dev/md0
>>>> real0m0.105s
>>>> user0m0.000s
>>>> sys0m0.007s
>>>>
>>>> nvme3n1           259:1    0   477G  0 disk
>>>> └─nvme3n1p1       259:10   0    50G  0 part
>>>> nvme4n1           259:2    0   477G  0 disk
>>>> └─nvme4n1p1       259:11   0    50G  0 part
>>>> nvme5n1           259:6    0   477G  0 disk
>>>> └─nvme5n1p1       259:12   0    50G  0 part
>>>> nvme2n1           259:9    0   477G  0 disk
>>>> └─nvme2n1p1       259:15   0    50G  0 part
>>>> nvme0n1           259:13   0   477G  0 disk
>>>> └─nvme0n1p1       259:14   0    50G  0 part
>>>>
>>>> v1:
>>>> Coly helps to review these patches and give some suggestions:
>>>> One bug is found. If discard bio is across one stripe but bio size is bigger
>>>> than one stripe size. After spliting, the bio will be NULL. In this version,
>>>> it checks whether discard bio size is bigger than 2*stripe_size.
>>>> In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
>>>> or not. It can avoid write memory to improve performance.
>>>> Add more comments for calculating addresses.
>>>>
>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> The code looks good to me, you may add my Reviewed-by: Coly Li
>>> <colyli@suse.de>
>>>
>>> But I still suggest you to add a more detailed commit log, to explain
>>> how the discard range of each component disk is decided. Anyway this is
>>> just a suggestion, it is up to you.
>>>
>>> Thank you for this work.
>> In raid10_end_discard_request(), the first 5 lines for local variables
>> declaration, there are 3 lines starts with improper blanks (should be
>> tab '\t'). You may find this minor issue by checkpatch.pl I guess.
>>
>> After fixing this format issue, you stil have my Reviewed-by :-)
>>
>> Coly Li
> Thanks to Xiao for the patch And thanks to Coly for the review.
>
> I did an experiment with a patch to increase max_discard_sectors,
> like:
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 14b1ba732cd7d..0b15397ebfaf9 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3762,7 +3762,7 @@ static int raid10_run(struct mddev *mddev)
>          chunk_size = mddev->chunk_sectors << 9;
>          if (mddev->queue) {
>                  blk_queue_max_discard_sectors(mddev->queue,
> -                                             mddev->chunk_sectors);
> +                                             UINT_MAX);
>                  blk_queue_max_write_same_sectors(mddev->queue, 0);
>                  blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
>                  blk_queue_io_min(mddev->queue, chunk_size);
>
> This simple change reduces the run time of mkfs.xfs on my SSD
> from 5+ minutes to about 14 seconds. Of course this is not as good
> as ~2s seconds with the set. But I wonder whether the time saving
> justifies extra complexity. Thoughts on this?
>
> Also, as Coly mentioned, please run checkpatch.pl on the patches.
> I have seen warnings on all 3 patches in the set.
>
> Thanks,
> Song
>
Hi Song

The mkfs.xfs still takes a very long time if just modifying the max 
discard sectors in my environment.
But it doesn't make sense in your test. It still needs to split the bio 
based on the chunk size. So it don't
make a difference only modifying the mas discard sectors?

And thanks Coly for the review. I'll fix the problem in the next version.

Regards
Xiao
