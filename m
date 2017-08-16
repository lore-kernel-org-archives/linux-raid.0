From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] Monitor: Include containers in spare migration
Date: Wed, 16 Aug 2017 09:06:13 -0400
Message-ID: <ac063625-11dc-d529-cd08-275570adaf77@gmail.com>
References: <1502888386-15946-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502888386-15946-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/16/2017 08:59 AM, Mariusz Tkaczyk wrote:
> Spare migration doesn't work for external metadata. mdadm skips
> a container with spare device because it is inactive. It used to work
> because GET_ARRAY_INFO ioctl returned valid structure for a container
> and mdadm treated such response as active container. Current
> implementation checks it in sysfs where container is shown as inactive.
> 
> Adapt sysfs implementation to work the same way as ioctl.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   Monitor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

