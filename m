From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/4] IMSM: Add support for 4Kn sector size drives
Date: Wed, 16 Nov 2016 10:14:36 -0500
Message-ID: <wrfj1syblan7.fsf@redhat.com>
References: <1478788098-32041-1-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1478788098-32041-1-git-send-email-pawel.baldysiak@intel.com>
        (Pawel Baldysiak's message of "Thu, 10 Nov 2016 15:28:14 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch set adds support for IMSM with 4Kn sector size drives
> First patch adds the generic function for receiving sector size,
> rest are IMSM specific.
> Internal calculation are still based on 512-bytes sector,
> variables are converted during read/write from/to member drive.
> Mixing of devices with different sector size is not allowed.
>
> Pawel Baldysiak (4):
>   Add function for getting member drive sector size
>   IMSM: Read and store device sector size
>   IMSM: Add support for 4Kn sector size drives
>   IMSM: 4Kn drives support - adapt general migration record
>
>  mdadm.h       |   1 +
>  super-intel.c | 315 +++++++++++++++++++++++++++++++++++++++++++++-------------
>  super1.c      |   3 +-
>  util.c        |  16 +++
>  4 files changed, 265 insertions(+), 70 deletions(-)

Hi Pawel,

This set mostly looks good - a couple of comments:

+int get_dev_sector_size(int fd, char *dname, unsigned int *sectsizep)

This introduces a *dname but nowhere in your code is it actually used. I
am not necessarily against this, and it looks like we do it in some
places, but not others. However do you anticipate using it in future
changes you have lined up?

I noticed you changed hard coded 512 byte limits to hard coded 4096
when rounding up sizes for posix_memalign() etc. Wouldn't it be cleaner
to introduce a MAX_SECTOR_SIZE or similar?

Cheers,
Jes
