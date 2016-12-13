From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] Always return last partition end address in 512B blocks
Date: Tue, 13 Dec 2016 09:09:41 -0500
Message-ID: <wrfjtwa7rkd6.fsf@redhat.com>
References: <1481635862-829-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481635862-829-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Tue, 13 Dec 2016 14:31:02 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> For 4K disks 'endofpart' is an index of the last 4K sector used by partition.
> mdadm is using number of 512-byte sectors, so value returned by
> get_last_partition_end must be multiplied by 8 for devices with 4K sectors.
> Also, unused 'ret' variable has been removed.
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  util.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes
