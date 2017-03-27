From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCHv2 0/2] mdadm: setting device role of raid1 disk with
 failfast
Date: Mon, 27 Mar 2017 12:59:24 +0200
Message-ID: <20170327105923.GA6557@ws00837>
References: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Is nobody interested in those patches?

On Mon, Mar 20, 2017 at 10:51:55AM +0100, Gioh Kim wrote:
> Hi,
> 
> I've found a case that failfast option of mdadm set a disk faulty wrongly.
> Following is my test case.
> 
> mdadm --create /dev/md100 -l 1 --failfast -e 1.2 -n 2 /dev/vdb /dev/vdc
> mdadm /dev/md100 -a --failfast /dev/vdd
> 
> If I use failfast option, the vdd disk was faulty wrongly.
> If not, it was spare.
> 
> This patch fixes a corner case for setting device role and
> prints device role if it's faulty.
> This patch is based on "mdadm - v4.0-8-g72b616a - 2017-03-07".
> 
> v2: fix a typo of v1
> 
> Gioh Kim (1):
>   super1: ignore failfast flag for setting device role
> 
> Jack Wang (1):
>   super1: check and output faulty dev role
> 
>  super1.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> -- 
> 2.5.0
> 

-- 
Best regards,
Gi-Oh Kim
TEL: 0176 2697 8962
