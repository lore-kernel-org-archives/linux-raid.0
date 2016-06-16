From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] imsm: add handling of sync_action is equal to 'idle'
Date: Thu, 16 Jun 2016 13:59:13 -0400
Message-ID: <wrfjeg7xow0e.fsf@redhat.com>
References: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
	<1466069497-29503-2-git-send-email-aleksey.obitotskiy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1466069497-29503-2-git-send-email-aleksey.obitotskiy@intel.com>
	(Alexey Obitotskiy's message of "Thu, 16 Jun 2016 11:31:36 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alexey Obitotskiy <aleksey.obitotskiy@intel.com> writes:
> After resync is stopped sync_action value become 'idle'.
> We treat this case as normal termination of waiting, not as error.
>
> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes

