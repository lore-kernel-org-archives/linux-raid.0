From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 2/5] mdadm/test: use the first element of array as parsing
 condition
Date: Fri, 1 Sep 2017 11:22:18 -0400
Message-ID: <5f56de82-c8fc-86c6-9ef6-189fb36114c7@gmail.com>
References: <1503912271-6463-1-git-send-email-zlliu@suse.com>
 <1503912271-6463-3-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1503912271-6463-3-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/28/2017 05:24 AM, Zhilong Liu wrote:
> it would complain "too many arguments" when array[] has
> few members, it's proper to check whether or not array[0]
> is null.
> 
> Reported-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   test | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

