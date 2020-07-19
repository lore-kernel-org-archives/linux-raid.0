From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH v4 0/2] md_cluster: bugs fix
Date: Sun, 19 Jul 2020 21:46:56 +0800
Message-ID: <ad5db04d-f5e0-4265-763e-b1f12b45e8c4@suse.com>
References: <1595156920-31427-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595156920-31427-1-git-send-email-heming.zhao@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes@trained-monkey.org, Song Liu <song@kernel.org>
List-Id: linux-raid.ids

Very sorry, I mistakenly added Jes, CC Song in this mail.

Jes, please ignore these patches, sorry for CC you.

On 7/19/20 7:08 PM, Zhao Heming wrote:
> v4:
> - add new patch 'fix rmmod issue when md_cluster convert bitmap to none'
> - add cover leter
> - modify both patches comments.
> 
> v3:
> - add restoring path for error case
> - modify comments
> 
> v2:
> - change setting path from location_store to md_setup_cluster
> - add restoring path
> 
> v1:
> - create: fix safemode_delay value when converting to clustered bitmap
> 
> Zhao Heming (2):
>    md-cluster: fix safemode_delay value when converting to clustered
>      bitmap
>    md-cluster: fix rmmod issue when md_cluster convert bitmap to none
> 
>   drivers/md/md.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
