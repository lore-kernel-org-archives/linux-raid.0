From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Use disk sector size value to set offset for reading GPT
Date: Mon, 12 Dec 2016 14:26:32 -0500
Message-ID: <wrfjwpf5rlsn.fsf@redhat.com>
References: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Thu, 8 Dec 2016 12:13:15 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> mdadm is using invalid byte-offset while reading GPT header to get
> partition info (size, first sector, last sector etc.). Now this offset
> is hardcoded to 512 bytes and it is not valid for disks with sector
> size different than 512 bytes because MBR and GPT headers are aligned
> to LBA, so valid offset for 4k drives is 4096 bytes.
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  super-gpt.c | 10 ++++++++++
>  util.c      |  7 ++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
