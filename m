From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Thu, 3 Sep 2009 13:43:44 -0400
Message-ID: <7d86ddb90909031043g35e960a5mf6c320f2fd23222f@mail.gmail.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
	 <C6C20E3B.CB5A%david@santools.com>
	 <714cf35c0909011414q1f081266u47f194431fcf3176@mail.gmail.com>
	 <7d86ddb90909011926u18ca2da7x644867ab5e7dbbfd@mail.gmail.com>
	 <714cf35c0909021103n6aa4a9d9w2699bebcc208862c@mail.gmail.com>
	 <7d86ddb90909021128s59f988bdn20795f60749fbc02@mail.gmail.com>
	 <7d86ddb90909021135r66a0a56dx580f34c0cf756382@mail.gmail.com>
	 <4A9FE5FD.5030709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A9FE5FD.5030709@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for pointing that out as that could cause some major issues for
people. I have expanded a number of hardware RAID and ext3 volumes,
but I never write out instructions. What seems like common knowledge
to me is not for others. Sorry for the confusion over leaving out the
partition number.

Ryan

On Thu, Sep 3, 2009 at 11:51 AM, Bill Davidsen<davidsen@tmr.com> wrote:
> Ryan Wagoner wrote:
>
> Forgot to mention that after you mount /dev/sda to verify that fdisk
> was done correctly you must unmount it before running fsck.
>
> umount /dev/sda
> fdisk /dev/sda (delete and recreate the partition to fill the entire volume)
>
> mount /dev/sda (make sure your files are accessible to verify you
> repartitioned it correctly)
> umount /dev/sda
>
> fsck -f /dev/sda
> resize2fs /dev/sda
> mount /dev/sda (df -h should show the volume with the additional space)
>
>
> I would say people should ignore these instructions, as they are flawed,
> since the fdisk applies to partitions, and all of the mount, umount, and
> *e2fs operations are shown on the entire disk. If you know enough to know
> when he means /dev/sda1 and when he doesn't, you probably don't need this
> anyway.
>
> Please don't save or use these instructions, used as written they don't
> work!
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>
> "Now we have another quarterback besides Kurt Warner telling us during
> postgame
> interviews that he owes every great thing that happens to him on a football
> field to his faith in Jesus. I knew there had to be a reason why the
> Almighty
> included a mute button on my remote."
> 			-- Arthur Troyer on Tim Tebow (Sports Illustrated)
>
