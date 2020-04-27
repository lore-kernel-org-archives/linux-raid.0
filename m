From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] udev: Ignore change event for imsm
Date: Mon, 27 Apr 2020 10:23:50 -0400
Message-ID: <4d9e6fc9-2099-edf7-8982-f4cc4a1068a1@trained-monkey.org>
References: <20200408144452.19275-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200408144452.19275-1-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/8/20 10:44 AM, Mariusz Tkaczyk wrote:
> When adding a device to a container mdadm has to close its file
> descriptor before sysfs_add_disk(). This generates change event.
> There is race possibility because metadata is already written and other
> -I process can place drive differently. As a result device can be added
> to two containers simultaneously.
> From IMSM perspective there is no need to react for change event. IMSM
> doesn't support stacked devices.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  udev-md-raid-assembly.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes
