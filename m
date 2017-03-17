From: jes.sorensen@gmail.com
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Fri, 17 Mar 2017 15:39:49 -0400
Message-ID: <wrfjpohfk7zu.fsf@gmail.com>
References: <20170315182850.3628010-1-songliubraving@fb.com>
        <20170315182850.3628010-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170315182850.3628010-2-songliubraving@fb.com> (Song Liu's
        message of "Wed, 15 Mar 2017 11:28:50 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> When journal device of an array fails, the array is forced into read-only
> mode. To make the array normal without adding another journal device, we
> need to remove journal _feature_ from the array.
>
> This patch is the mdadm part of removing journal feature for an array with
> failed or missing journal.
>
> Two flags are added to GET_ARRAY_INFO:
>   1. MD_SB_HAS_JOURNAL: meaning the array have journal feature;
>   2. MD_SB_JOURNAL_REMOVABLE: meaning the journal is faulty or missing
>
> When both flags are set, mdadm will use ioctl SET_ARRAY_INFO to clear
> MD_SB_HAS_JOURNAL, and thus remove journal feature from the array.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Manage.c | 26 ++++++++++++++++++++++++++
>  ReadMe.c |  1 +
>  mdadm.c  |  9 ++++++++-
>  mdadm.h  |  3 +++
>  4 files changed, 38 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
