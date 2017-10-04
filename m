From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] mdmon: get safe mode delay file descriptor early
Date: Wed, 4 Oct 2017 11:42:08 -0400
Message-ID: <96f42eea-9fdd-02cf-6f5c-79606644dee8@gmail.com>
References: <f223d535-5fed-0c97-a7b2-6c4eb9e46484@gmail.com>
 <1507105101-19475-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507105101-19475-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/04/2017 04:18 AM, Tomasz Majchrzak wrote:
> After switch root new mdmon is started. It sends initrd mdmon a signal
> to terminate. initrd mdmon receives it and switches the safe mode delay
> to 1 ms in order to get array to clean state and flush last version of
> metadata. The problem is sysfs filesystem is not available to initrd mdmon
> after switch root so the original safe mode delay is unchanged. The delay
> is set to few seconds - if there is a lot of traffic on the filesystem,
> initrd mdmon doesn't terminate for a long time (no clean state). There
> are 2 instances of mdmon. initrd mdmon flushes metadata when array goes
> to clean state but this metadata might be already outdated.
> 
> Use file descriptor obtained on mdmon start to change safe mode delay.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   managemon.c | 16 +++++++++++++---
>   mdmon.h     |  1 +
>   2 files changed, 14 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes

