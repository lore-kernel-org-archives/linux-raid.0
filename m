From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v1 1/2] mdadm/manpage:update manpage for readonly
 parameter
Date: Wed, 12 Apr 2017 13:51:28 -0400
Message-ID: <15e83951-80a0-753b-3078-a7defe5d7e90@gmail.com>
References: <6afe1397-3063-c5d7-58ba-f3dbdfa05336@gmail.com>
 <1491986198-16642-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491986198-16642-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/2017 04:36 AM, Zhilong Liu wrote:
> update readonly in manpage:
> Currently both the readwrite and readonly are worked well,
> update the readonly section.
> One commit in linux/driver/md. Cleared "MD_CLOSING bit" to
> Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.8.in | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes

> diff --git a/mdadm.8.in b/mdadm.8.in
> index 744c12b..f10a8b8 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -925,7 +925,8 @@ will not try to be so clever.
>  Start the array
>  .B read only
>  rather than read-write as normal.  No writes will be allowed to the
> -array, and no resync, recovery, or reshape will be started.
> +array, and no resync, recovery, or reshape will be started. It works with
> +Create, Assemble, Manage and Misc mode.
>
>  .TP
>  .BR \-a ", " "\-\-auto{=yes,md,mdp,part,p}{NN}"
> @@ -2232,7 +2233,7 @@ be in use.
>
>  .TP
>  .B \-\-readonly
> -start the array readonly \(em not supported yet.
> +start the array in readonly mode.
>
>  .SH MANAGE MODE
>  .HP 12
>

