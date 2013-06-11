From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 11 Jun 2013 10:12:12 -0700
Message-ID: <51B75A6C.1040204@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACAAB2.5010904@zytor.com> <20130611124740.521f886a@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130611124740.521f886a@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/11/2013 09:47 AM, Joe Lawrence wrote:
> 
> You've probably worked around this by now, but Dan's suggestion can be
> tweaked if you are willing to fail/remove/re-add one of the disks.  I
> just verified the following:
> 
>   /sys/block/md125/queue/write_same_max_bytes: 524288
> 
> % mdadm --fail /dev/md125 /dev/sds1
> % mdadm --remove /dev/md125 /dev/sds1
> % echo 0 > /sys/class/scsi_disk/2\:0\:2\:0/max_write_same_blocks
> % mdadm --add /dev/md125 /dev/sds1
> 
>   /sys/block/md125/queue/write_same_max_bytes: 0
> 
> That gets raid10.c to invoke disk_stack_limits (via raid10_add_disk)
> which will recalculate write_same_max_bytes for the MD.
> 

No thanks.  I just hacked the kernel directly.

	-hpa


