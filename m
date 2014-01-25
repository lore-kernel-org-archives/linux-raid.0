From: "George Spelvin" <linux@horizon.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: 24 Jan 2014 20:18:32 -0500
Message-ID: <20140125011832.23432.qmail@science.horizon.com>
References: <CAH3kUhGA8x_5hDbqxcskHQq+5YXFrz4XspmzeTq0O8dQci8zzw@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhGA8x_5hDbqxcskHQq+5YXFrz4XspmzeTq0O8dQci8zzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, rspadim@gmail.com
Cc: linux-raid@vger.kernel.org, linux@horizon.com, matthew.garman@gmail.com
List-Id: linux-raid.ids

> the best i got is:
> if you want raid1 you will run a system like databases, or multi
> thread systems, each thread operating a disk
> if have a system with continous read/write (dvr, stream, etc) raid10
> far is the best

Thank you for the respose, but I'm a little confused  Can you clarify?

I'm not sure which of three things you're suggesting.
Are you talking about the actual data layout, or the Linux driver?


Obviously, if I added disks and striped across them, sequential
performance would go up.  This is an actual RAID-10 layout.
But it's not useful unless I buy more disks.


But there's also the case that I can use the kernel raid10 driver with
an n2 layout.  This has the same disk layout as raid1, but might have
different preformance.  Is that what you mean?  In that case, it would be
nice to either copy the improvements to the raid1 driver, or make the
raid10 driver able to handle raid1 arrays and throw out the raid1 driver.


Finally, a third option is that you're talking about the raid10
driver, but with a far or offset layout.  I haven't played with those.
