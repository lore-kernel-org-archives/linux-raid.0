From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Add udev-md-raid-safe-timeouts.rules
Date: Thu, 1 Feb 2018 09:09:41 -0500
Message-ID: <c8b5f5ec-b14f-de9e-925d-e8e4a9ff4524@gmail.com>
References: <20180126235426.8148-1-jonathan.underwood@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180126235426.8148-1-jonathan.underwood@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan G. Underwood" <jonathan.underwood@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/26/2018 06:54 PM, Jonathan G. Underwood wrote:
> From: Jonathan Underwood <jonathan.underwood@gmail.com>
> 
> These udev rules attempt to set a safe kernel controller
> timeout for disks containing RAID level 1 or higher
> partitions for commodity disks which do not have SCTERC
> capability, or do have it but it is disabled.
> 
> No attempt is made to change the STCERC settings on devices
> which support it.
> 
> This attempts to mitigate the problem described here:
> 
>     https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>     http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/
> 
> where the kernel controller may timeout on a read from a
> disk after the default timeout of 30 seconds and consequently
> cause mdraid to regard the disk as dead and eject it from the
> RAID array.
> 
> The mitigation is to set the timeout to 180 seconds for disks
> which contain a RAID level 1 or higher partition.
> 
> Signed-off-by: Jonathan G. Underwood <jonathan.underwood@gmail.com>
> ---
>  udev-md-raid-safe-timeouts.rules | 61 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 udev-md-raid-safe-timeouts.rules

Applied!

Thanks,
Jes


