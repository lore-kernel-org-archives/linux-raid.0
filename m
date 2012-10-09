From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Tue, 09 Oct 2012 10:54:37 +0200
Message-ID: <5073E64D.2020506@profitbricks.com>
References: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com> <20121003083031.51093f0c@notabene.brown> <50730010.5090605@profitbricks.com> <20121009140248.3ad91484@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121009140248.3ad91484@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09.10.2012 05:02, NeilBrown wrote:
> Kernel sometimes knows. Some arrays have metadata handled by user-space so
> the kernel wouldn't be able to report anything.
> Userspace always knows..

Thanks for the hint. I didn't think about that.

> In that case, how about using /run/mdadm/map ??
> When mdadm assembles an array it needs to know the uuid, and it
records this
> in that file for future reference. Will that do?

Thanks for the hint. Our 3.2.5-Version didn't build it for an existing
location. I made it do so but I don't like the UUID format in there.

I assembled UUID 12345678:12345678:12345678:12345678 and the file
contains the following:

md0 1.2 78563412:78563412:78563412:78563412 /dev/md0

This would be a nice file if I could grep for the UUID in the same
format as I've entered it upon creation/assembly.
So, I guess we can live with a custom patch for now and close the
discussion here.

>> Btw.: We did an "Assemble-Resize-Stop, Assemble-Resize-Stop, ..."-Test
>> with "--assume-clean" and the second resize doesn't work. With
>> "Assemble-Resize-Detail-Stop" it works.
>
> More details? What exactly do you mean by "Resize"? What exactly do you
> mean by "doesn't work"? Can you make a simple script that reproduces this?
> If so, I'd love to see it.

I'll open a new topic for this after analysing it in more detail today.
I've only seen the issue on the PC of my boss and some automation guys
reported it.

Cheers,
Sebastian

