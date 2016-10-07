From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: retrieve nvme serial from sysfs
Date: Fri, 07 Oct 2016 11:19:00 -0400
Message-ID: <wrfjoa2wdw63.fsf@redhat.com>
References: <20161006091309.27263-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006091309.27263-1-artur.paszkiewicz@intel.com> (Artur
        Paszkiewicz's message of "Thu, 6 Oct 2016 11:13:09 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> Don't rely on SCSI ioctl for reading NVMe serials - SCSI emulation for
> NVMe devices can be disabled in the kernel config. Instead, try to get a
> serial from /sys/block/nvme*/device/serial. If that fails for whatever
> reason (i.e. no such attribute in old kernels) - fall back to the SCSI
> method.
>
> This also moves some SCSI-specific code from imsm_read_serial() to
> scsi_get_serial().
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> ---
>  sg_io.c       | 23 +++++++++++++++++++----
>  super-intel.c | 46 +++++++++++++++++++++++++++-------------------
>  2 files changed, 46 insertions(+), 23 deletions(-)

Hi Artur,

Looks quite reasonable - applied!

Thanks,
Jes
