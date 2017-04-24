From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Don't use UnSet with consistency_policy
Date: Mon, 24 Apr 2017 17:11:25 -0400
Message-ID: <64c55eb2-37a7-4f3c-e0cb-4b3e6e77e9a0@gmail.com>
References: <20170424140326.2707-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424140326.2707-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2017 10:03 AM, Artur Paszkiewicz wrote:
> Use CONSISTENCY_POLICY_UNKNOWN instead. Simplify some checks because
> since 5e8e35fb7e17 ("maps: Use keyvalue for null terminator to indicate
> 'unset' value") map_name() can return this default directly.
>
> Suggested-by: Jes Sorensen <Jes.Sorensen@gmail.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  maps.c        |  2 +-
>  mdadm.c       | 12 ++++++------
>  super-intel.c |  4 +---
>  sysfs.c       | 10 ++++------
>  4 files changed, 12 insertions(+), 16 deletions(-)

Applied!

Thanks,
Jes


