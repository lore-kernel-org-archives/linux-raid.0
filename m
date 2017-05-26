From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [Patch v5] super1: fix sb->max_dev when adding a new disk in
 linear array
Date: Fri, 26 May 2017 14:35:51 -0400
Message-ID: <daa37d68-1fa2-1a6d-7a2d-915219d23cbe@gmail.com>
References: <20170525092811.3868-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170525092811.3868-1-lzhong@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org, neilb@suse.com
Cc: colyli@suse.com
List-Id: linux-raid.ids

On 05/25/2017 05:28 AM, Lidong Zhong wrote:
> The value of sb->max_dev will always be increased by 1 when adding
> a new disk in linear array. It causes an inconsistence between each
> disk in the array and the "Array State" value of "mdadm --examine DISK"
> is wrong. For example, when adding the first new disk into linear array
> it will be:
> 
> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' == active, '.' == missing, 'R' == replacing)
> 
> Adding the second disk into linear array it will be
> 
> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' == active, '.' == missing, 'R' == replacing)
> 
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>   super1.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes

