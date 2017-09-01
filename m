From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 4/5] mdadm/test: get rid of tests/check
Date: Fri, 1 Sep 2017 11:27:26 -0400
Message-ID: <0310c468-321b-6db5-b869-56dcdfd816b8@gmail.com>
References: <1503912271-6463-1-git-send-email-zlliu@suse.com>
 <1503912271-6463-5-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1503912271-6463-5-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/28/2017 05:24 AM, Zhilong Liu wrote:
> The tests/check can be removed due to check()
> in new 'test' has covered various checking.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   tests/check | 35 -----------------------------------
>   1 file changed, 35 deletions(-)
>   delete mode 100644 tests/check

Applied!

Thanks,
Jes


