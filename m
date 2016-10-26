From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] IMSM: Add warning message when x8-type device is used
Date: Wed, 26 Oct 2016 12:02:22 -0400
Message-ID: <wrfjk2cvm73l.fsf@redhat.com>
References: <1477297192-5646-1-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477297192-5646-1-git-send-email-pawel.baldysiak@intel.com>
        (Pawel Baldysiak's message of "Mon, 24 Oct 2016 10:19:52 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch adds the warning message when x8-type device
> is used with IMSM metadata. x8 device is a special
> NVMe drive - two of them on a single PCIe card.
> This card could be a single point of failure for
> RAID levels different than RAID0. x8 devices have
> serial number ending with "-A/-B" or "-1/-2".
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)

Applied!

Thanks,
Jes
