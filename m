From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 1/4] Grow_continue_command: ensure 'content' is
 properly initialised.
Date: Thu, 20 Apr 2017 12:56:41 -0400
Message-ID: <944080bd-73a2-9e19-75c5-2065355214ab@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600552.31004.6577040107424525064.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265600552.31004.6577040107424525064.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2017 10:40 PM, NeilBrown wrote:
> Grow_continue_command() call verify_reshape_position(), which assumes
> that info->sys_name is initialised.
> 'info' in verify_reshape_position() is 'content' in Grow_continue_command().
>
> In the st->ss->external != 0 branch of that function, sysfs_init() is called
> to initialize content->sys_name.
> In the st->ss->external == 0 branch, ->sys_name is not initialized so
> verify_reshape_position() will not do the right thing.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Grow.c |    1 +
>  1 file changed, 1 insertion(+)

Applied!

Thanks,
Jes


