From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] IMSM: Add support for Non-Intel NVMe drives under VMD
Date: Mon, 12 Dec 2016 14:23:54 -0500
Message-ID: <wrfja8c1t0hh.fsf@redhat.com>
References: <20161212102844.26697-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161212102844.26697-1-pawel.baldysiak@intel.com> (Pawel
        Baldysiak's message of "Mon, 12 Dec 2016 11:28:44 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch adds checking if platform (preOS) supports
> non-Intel NVMe drives under VMD domain,
> and - if so - allow creating IMSM Raid Volume
> with those drives.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  platform-intel.h |  7 +++++++
>  super-intel.c    | 12 +++++++++---
>  2 files changed, 16 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes
