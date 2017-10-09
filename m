From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 1/3] mdadm/grow: Component size must be larger than chunk
 size
Date: Mon, 9 Oct 2017 09:17:41 +0200
Message-ID: <20171009071741.GA5454@proton.igk.intel.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com>
 <1504604498-26048-2-git-send-email-zlliu@suse.com>
 <20171005114430.GA24654@proton.igk.intel.com>
 <674a1606-c3cb-3043-165c-1ca5400a4626@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <674a1606-c3cb-3043-165c-1ca5400a4626@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

On Mon, Oct 09, 2017 at 11:32:09AM +0800, Zhilong Liu wrote:
> 
> 
> On 10/05/2017 07:44 PM, Tomasz Majchrzak wrote:
> >On Tue, Sep 05, 2017 at 05:41:36PM +0800, Zhilong Liu wrote:
> >>Grow: Changing component size must be larger than current
> >>chunk size against stripe raids, otherwise Grow_reshape()
> >>would set s->size to '0'.
> >>
> >>Signed-off-by: Zhilong Liu <zlliu@suse.com>
> >>---
> >>  Grow.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >>diff --git a/Grow.c b/Grow.c
> >>index 534ba80..f0a21ff 100644
> >>--- a/Grow.c
> >>+++ b/Grow.c
> >>@@ -1816,6 +1816,12 @@ int Grow_reshape(char *devname, int fd,
> >>  		return 1;
> >>  	}
> >>+	if (array.level > 1 &&
> >>+	   (array.chunk_size / 1024) > (int)s->size) {
> >>+		pr_err("component size must be larger than chunk size.\n");
> >>+		return 1;
> >>+	}
> >>+
> >>  	st = super_by_fd(fd, &subarray);
> >>  	if (!st) {
> >>  		pr_err("Unable to determine metadata format for %s\n", devname);
> >>-- 
> >>2.6.6
> >
> >Hi Zhilong Liu,
> >
> >Above patch has broken RAID level conversion:
> >
> >Before the patch:
> >
> >mdadm --create /dev/md/raid --level=10 --raid-devices=4 /dev/nvme0n1
> >/dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
> >MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/raid --level=0
> >mdadm: level of /dev/md/raid changed to raid0
> >
> >After the patch:
> >
> >mdadm --create /dev/md/raid --level=10 --raid-devices=4 /dev/nvme0n1
> >/dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
> >MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/raid --level=0
> >mdadm: component size must be larger than chunk size.
> >
> >Could you take a look at it, please?
> 
> Hi, Tomek;
>   I just back from vacation, and this is very important info for me,
> thanks very much.
> Against this issue, the codes should be proper like:
> 
> diff --git a/Grow.c b/Grow.c
> index 1149753..180fd78 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1814,7 +1814,8 @@ int Grow_reshape(char *devname, int fd,
>         }
> 
>         if (array.level > 1 &&
> -          (array.chunk_size / 1024) > (int)s->size) {
> +          (array.chunk_size / 1024) > (int)s->size &&
> +           s->level == UnSet) {
>                 pr_err("component size must be larger than chunk size.\n");
>                 return 1;
>         }
> 
> Is this changing good for you? Any ideas is very welcome.
> 

Yes, the above scenario works fine. Please send it as official patch.

Thanks,

Tomek
