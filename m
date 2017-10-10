From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 3/3] mdadm/mdstat: correct the strncmp number 4 as 6
Date: Tue, 10 Oct 2017 16:38:17 -0400
Message-ID: <e747024a-d0fc-53d4-77b9-8440c3466461@gmail.com>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com>
 <1507537274-29350-4-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-4-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2017 04:21 AM, Zhilong Liu wrote:
> mdstat: it should be corrected as 6 when strncmp 'resync'.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   mdstat.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

