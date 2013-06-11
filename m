From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 11 Jun 2013 12:47:40 -0400
Message-ID: <20130611124740.521f886a@jlaw-desktop.mno.stratus.com>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACAAB2.5010904@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51ACAAB2.5010904@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 03 Jun 2013 07:39:46 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/02/2013 11:14 PM, Dan Williams wrote:
> > On Sun, Jun 2, 2013 at 11:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> On 06/02/2013 10:47 PM, Dan Williams wrote:
> >>>
> >>> One hack to prove this may be to explicitly disable write_same before
> >>> the array is assembled:
> >>>
> >>> for i in /sys/class/scsi_disk/*/max_write_same_blocks; do echo 0 > $i; done
> >>>
> >>> If this works then maybe md needs to be tolerant of write_same
> >>> failures since the block layer will simply retry with zeroes.
> >>>
> >>
> >> Trying that (array is already assembled but is currently functional.)
> >> Let's hope it works.
> >>
> > 
> > If I'm reading things correctly that may still result in failure since
> > md will still pass the REQ_WRITE_SAME bios down to the the devices and
> > will receive BLK_PREP_KILL for its trouble.  md only notices that
> > write same is disabled on underlying devices at assembly time.
> > 
> 
> Hmmm... that means getting dracut/udev to supply this little mod, unless
> it can be fed as a kernel command-line option somehow.  Digging...
> 
> 	-hpa

You've probably worked around this by now, but Dan's suggestion can be
tweaked if you are willing to fail/remove/re-add one of the disks.  I
just verified the following:

  /sys/block/md125/queue/write_same_max_bytes: 524288

% mdadm --fail /dev/md125 /dev/sds1
% mdadm --remove /dev/md125 /dev/sds1
% echo 0 > /sys/class/scsi_disk/2\:0\:2\:0/max_write_same_blocks
% mdadm --add /dev/md125 /dev/sds1

  /sys/block/md125/queue/write_same_max_bytes: 0

That gets raid10.c to invoke disk_stack_limits (via raid10_add_disk)
which will recalculate write_same_max_bytes for the MD.

Regards,

-- Joe
