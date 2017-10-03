From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: Set disk slot number
Date: Tue, 3 Oct 2017 14:28:02 -0400
Message-ID: <bbbfeb18-b754-7e37-0a77-987385bccf35@gmail.com>
References: <1507034989-12264-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507034989-12264-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/03/2017 08:49 AM, Mariusz Tkaczyk wrote:
> If first disk of IMSM RAID1 is failed but still present in the system,
> the array is not auto-assembled. Auto-assemble uses raid disk slot from
> metadata to index disks. As it's not set, the valid disk is seen as a
> replacement disk and its metadata is ignored. The problem is not
> observed for other RAID levels as they have more than 2 disks -
> replacement disks are only stored under uneven indexes so third disk
> metadata is used in such scenario.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   super-intel.c | 3 +++
>   1 file changed, 3 insertions(+)

Applied!

Thanks,
Jes

