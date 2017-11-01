From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm/mdopen: create new function create_named_array for
 writing to new_array
Date: Wed, 1 Nov 2017 17:23:53 -0400
Message-ID: <9f9ada31-386d-2f91-9e03-65d5396c2c92@gmail.com>
References: <1508140458-16435-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1508140458-16435-1-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/16/2017 03:54 AM, Zhilong Liu wrote:
> Split 'write to new_array' out into a function named create_named_array.
> And fixed a trivial compiling warning 'warn_unused_result' against commit:
> fdbf7aaa1956 (mdopen: call "modprobe md_mod" if it might be needed.)
> 
> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
> 
> Discussed this issue with mail: 
> [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
> 
>  mdopen.c | 47 +++++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)

Applied!

Thanks,
Jes


