From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Growing a 5-drive RAID6 - some initial questions
Date: Thu, 20 Jun 2013 08:42:08 -0700
Message-ID: <CAK2H+ecSAZiZorRpP3sYpLBkH8E5EV=Goy0rj7Es0_yUJohMmQ@mail.gmail.com>
References: <CAK2H+edY8VKauwivLU5SJ6EU_ZOkTqxGvecYTNW2s5yC-xN4Og@mail.gmail.com>
	<CAK2H+efK6xt4N=dS4xjTgQSk_mAtvRZP1d2sEzsQXz5=vZANOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efK6xt4N=dS4xjTgQSk_mAtvRZP1d2sEzsQXz5=vZANOQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 20, 2013 at 8:08 AM, Mark Knecht <markknecht@gmail.com> wrote:
<SNIP>
> A couple of follow-up questions if anyone has info & time to answer.
> My kernel is 3.8.13-gentoo. I'm using mdadm-3.1.4.
>
> I'm currently doing the recovery step on the 5th of 5 drives so the
> next step is the one that will grow the RAID:
>
> mdadm --grow /dev/md0 --size=max
>
> 1) With regards to growing the array, a long time ago I remember
> growing a RAID and getting burned by a bug that didn't like the ending
> sector number. Something about the size of the RAID not being
> divisible by chunk size or something like that. At that time I was not
> using RAID6. Are there any known problems like that at this time for
> RAID6?
>
> 2) Out of curiosity, is it the grow command that creates the ext4
> filesystem on the new portion of the RAID or is there some step not
> shown at the link able where I need to do some file system in this
> process? Or possibly the mdadm --add step?

On this part I see it's the resize2fs command further down in the
document. Sorry for the noise.

Still interested in an known bugs in the --grow=max part if there are any.

Thanks,
Mark
