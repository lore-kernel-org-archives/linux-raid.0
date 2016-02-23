From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: [PATCH 2/2] enable bypass raid5 journal for full stripe writes
Date: Tue, 23 Feb 2016 10:34:05 -0600
Message-ID: <CAB-428=d=6_mNc+2-Y965xG4TFwOFVify3Efymmu9NQBB_mxMQ@mail.gmail.com>
References: <1455151995-240805-1-git-send-email-songliubraving@fb.com> <1455151995-240805-2-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1455151995-240805-2-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Shaohua Li <shli@fb.com>, hch@infradead.org, kernel-team@fb.com, Tony Floeder <Tony_Floeder@dell.com>
List-Id: linux-raid.ids

On Wed, Feb 10, 2016 at 6:53 PM, Song Liu <songliubraving@fb.com> wrote:
> Summary:
>
> Resending the patch to see whether we can get another chance...
>
> When testing current SATA SSDs as the journal device, we have
> seen 2 challenges: throughput of long sequential writes, and
> SSD life time.
>
> To ease the burn on the SSD, we tested bypassing journal for
> full stripe writes. We understand that bypassing journal will
> re-introduce write hole to the md layer. However, with
> well-designed application and file system, such write holes
> should not result in any data loss.

To me the probability of data-lost during a full-stripe write is more
than partial-stripe write. I understand your motivation of doing this
however as Neil mentioned, this trade-off and your assumption about
the "well-designed application and file system" put a question mark on
the general usage of MD journal.

> Our test systems have 2 RAID-6 array per server and 15 HDDs
> per array. These 2 arrays shared 1 SSD as the journal (2
> partitions). Btrfs is created on both array.
>
> For squential write benchmarks, we observe significant
> performance gain (250MB/s per volume vs. 150M/s) from
> bypassing journal for full stripes.
>
> We all performed power cycle tests on these systems while
> running a write workload. For more than 50 power cycles,
> we have seen zero data loss.
>

Is it possible to share more details about your power cycle test
procedure and data loss detection method?

> To configure the bypass feature:
>
> echo 1 > /sys/block/mdX/md/r5l_bypass_full_stripe
>
> and
>
> echo 0 > /sys/block/mdX/md/r5l_bypass_full_stripe
>
> For file system integrity, the code does not bypass any write
> with REQ_FUA.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
