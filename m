From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 1/1] Remove the legacy whitespace
Date: Tue, 11 Feb 2020 21:41:46 +0800
Message-ID: <3334dde5-6947-167b-bcbc-cdae47ce2864@redhat.com>
References: <1581428285-12008-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1581428285-12008-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: ptoscano@redhat.com, ncroxon@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

Please ignore this patch. I missed another place that needs to modify. I'll

send a new patch later.

Regards

Xiao


On 02/11/2020 09:38 PM, Xiao Ni wrote:
> The whitespace between Environment= and the true value causes confusion.
> To avoid confusing other people in future, remove the whitespace to keep
> it a simple, unambiguous syntax
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   systemd/mdcheck_continue.service | 2 +-
>   systemd/mdcheck_start.service    | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/systemd/mdcheck_continue.service b/systemd/mdcheck_continue.service
> index aa02dde..854317f 100644
> --- a/systemd/mdcheck_continue.service
> +++ b/systemd/mdcheck_continue.service
> @@ -11,7 +11,7 @@ ConditionPathExistsGlob = /var/lib/mdcheck/MD_UUID_*
>   
>   [Service]
>   Type=oneshot
> -Environment= "MDADM_CHECK_DURATION=6 hours"
> +Environment="MDADM_CHECK_DURATION=6 hours"
>   EnvironmentFile=-/run/sysconfig/mdadm
>   ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
>   ExecStart=/usr/share/mdadm/mdcheck --continue --duration ${MDADM_CHECK_DURATION}
> diff --git a/systemd/mdcheck_start.service b/systemd/mdcheck_start.service
> index da62d5f..3bb3d13 100644
> --- a/systemd/mdcheck_start.service
> +++ b/systemd/mdcheck_start.service
> @@ -11,7 +11,7 @@ Wants=mdcheck_continue.timer
>   
>   [Service]
>   Type=oneshot
> -Environment= "MDADM_CHECK_DURATION=6 hours"
> +Environment="MDADM_CHECK_DURATION=6 hours"
>   EnvironmentFile=-/run/sysconfig/mdadm
>   ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
>   ExecStart=/usr/share/mdadm/mdcheck --duration ${MDADM_CHECK_DURATION}
