From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Lib.c: Fix geting devname for devices with long path
Date: Wed, 26 Oct 2016 12:03:36 -0400
Message-ID: <wrfjbmy7m71j.fsf@redhat.com>
References: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
        <1477042671-12934-4-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477042671-12934-4-git-send-email-pawel.baldysiak@intel.com>
        (Pawel Baldysiak's message of "Fri, 21 Oct 2016 11:37:51 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> In scenario where VMD is enabled, and "x8" type of NVMe drive is
> plugged into PCIe switch - the path will be longer than 200 chars
> (additional VMD domain + 2 level of PCIe switches).
> This patch makes the buffer big enough to handle this kind of
> configurations.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes
