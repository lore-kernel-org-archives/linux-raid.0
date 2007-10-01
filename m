From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID5 lockup with AMCC440 and async-tx
Date: Mon, 1 Oct 2007 06:13:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710010613260.15248@p34.internal.lan>
References: <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dale Dunlea <ddunlea@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide-arrays@lists.math.uh.edu
List-Id: linux-raid.ids



On Mon, 1 Oct 2007, Dale Dunlea wrote:

> Hi,
>
> I have a board with an AMCC440 processor, running RAID5 using the
> async-tx interface. In general, it works well, but I have found a test
> case that consistently causes a hard lockup of the entire system.
>
> What makes this case odd is that I have only been able to generate it
> when accessing disks that are on two separate HBAs - in my case
> mpt-fusion based SAS HBAs. Once two HBAs are in use, the bug is
> trivial to repeat. I simply create a RAID5 using disks from each HBA,
> wait for it to resync, and then run
>
> "dd if=/dev/zero of=/dev/md0 bs=512 count=100000".
>
> By disabling CONFIG_DMA_ENGINE in my kernel config, the hang goes
> away, but then so does my performance.
>
> Any pointers on how to debug this? It feels like a race condition of
> some description, but any serial port printing I enable causes the
> problem to go away, and I can't print silently to /var/log/messages as
> the system hangs before it can flush.
>
> Regards,
> Dale
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Added linux-ide-arrays to the CC list which is probably better suited 
towards this kind of question.

Justin.
