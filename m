From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] mdmon.8: fix possible typos
Date: Tue, 28 Jun 2011 16:38:00 +1000
Message-ID: <20110628163800.2ba5aac6@notabene.brown>
References: <1308889610-8210-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308889610-8210-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 Jun 2011 13:26:49 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  mdmon.8 |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mdmon.8 b/mdmon.8
> index 7939a99..03b31b8 100644
> --- a/mdmon.8
> +++ b/mdmon.8
> @@ -104,7 +104,7 @@ within those disks.  MD metadata in comparison defines a 1:1
>  relationship between a set of block devices and a raid array.  For
>  example to create 2 arrays at different raid levels on a single
>  set of disks, MD metadata requires the disks be partitioned and then
> -each array can created be created with a subset of those partitions.  The
> +each array can be created with a subset of those partitions.  The
>  supported external formats perform this disk carving internally.
>  .P
>  Container devices simply hold references to all member disks and allow
> @@ -172,7 +172,7 @@ Note that
>  is automatically started by
>  .I mdadm
>  when needed and so does not need to be considered when working with
> -RAID arrays.  The only times it is run other that by
> +RAID arrays.  The only times it is run other than by
>  .I  mdadm
>  is when the boot scripts need to restart it after mounting the new
>  root filesystem.


Thanks.  I've applied both of these.

NeilBrown
