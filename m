From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] IMSM: Enable spanning between VMD domains
Date: Wed, 26 Oct 2016 12:03:10 -0400
Message-ID: <wrfjfunjm729.fsf@redhat.com>
References: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
        <1477042671-12934-3-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477042671-12934-3-git-send-email-pawel.baldysiak@intel.com>
        (Pawel Baldysiak's message of "Fri, 21 Oct 2016 11:37:50 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> Each VMD domain adds additional PCI domain. This patch
> enables RAID creation with NVMe drives from different
> VMD domains.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)

Applied!

Thanks,
Jes
