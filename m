From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: count arrays under VMD HBAs correctly
Date: Mon, 09 Jan 2017 07:49:16 -0500
Message-ID: <wrfjk2a4flf7.fsf@redhat.com>
References: <1483963942-24774-1-git-send-email-aleksey.obitotskiy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1483963942-24774-1-git-send-email-aleksey.obitotskiy@intel.com>
        (Alexey Obitotskiy's message of "Mon, 9 Jan 2017 13:12:22 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alexey Obitotskiy <aleksey.obitotskiy@intel.com> writes:
> OROM defines maximum number of arrays supported. On array creation mdadm
> checks if number of arrays doesn't exceed that limit, however it is not
> calculated correctly for VMD now.
>
> The current code performs a lookup of HBA using the id. VMD HBAs have
> the same id so each lookup returns the same structure (first
> encountered). Take a different approach for VMD HBAs. As id is not
> unique and cannot be used for lookups, iterate over all VMD HBAs and
> compare both id and HBA path.
>
> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> ---
>  platform-intel.c | 10 ++++++++++
>  platform-intel.h |  1 +
>  super-intel.c    | 48 ++++++++++++++++++++++++++++++++++++------------
>  3 files changed, 47 insertions(+), 12 deletions(-)

Applied!

Thanks,
Jes
