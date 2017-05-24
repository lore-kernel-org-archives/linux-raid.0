From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Detail: don't exit if ioctl has been successful
Date: Wed, 24 May 2017 13:28:49 -0400
Message-ID: <6ff3ea15-c767-ed9a-b2d7-00a387198b3c@gmail.com>
References: <1495618462-23016-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1495618462-23016-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/24/2017 05:34 AM, Tomasz Majchrzak wrote:
> When GET_ARRAY_INFO ioctl is successful, mdadm exits with an error.
> It breaks udev and no links in /dev/md are created.
> 
> Also change debug print to error print in the message indicating lack
> of the link to facilitate debugging similar issues in the future.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Detail.c | 27 +++++++++++++++------------
>   util.c   |  2 +-
>   2 files changed, 16 insertions(+), 13 deletions(-)

Applied!

Thanks,
Jes

