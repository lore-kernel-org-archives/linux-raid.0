From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Mon, 08 Oct 2012 18:32:16 +0200
Message-ID: <50730010.5090605@profitbricks.com>
References: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com> <20121003083031.51093f0c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121003083031.51093f0c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I must have overseen your answer. We want to use as less mdadm as
possible - especially for simple checking stuff. The kernel knows best.
"mdadm -D" reads the data from disk. This means additional disk access.
It is also possible that this command triggers superblock updates.
Simple checking stuff shouldn't have to use disk access.

We are planning to use MD RAID a little bit different with e.g. 100 MD
arrays. Searching for a particular UUID in this bunch of MD devices can
be difficult without this patch. This is how the kernel represents
UUIDs. Conversion can be done in user space.

If you like it better in the xxxxxxxx:xxxxxxxx:xxxxxxxx:xxxxxxxx format,
I can resend the patch in that format.

It simplifies our checking magic not to rely on udev symlinks and to ask
the kernel for the cached UUID.

Btw.: We did an "Assemble-Resize-Stop, Assemble-Resize-Stop, ..."-Test
with "--assume-clean" and the second resize doesn't work. With
"Assemble-Resize-Detail-Stop" it works.

Cheers,
Sebastian


On 03.10.2012 00:30, NeilBrown wrote:
> On Tue, 2 Oct 2012 15:42:10 +0200 Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
>
>> Report the UUID of the MD array in the following format:
>> xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
>>
>> This is useful if you don't want to wait for udev to
>> identify your MD array.
>
> If you don't want to wait for udev, run "mdadm -D --export
/dev/mdwhatever"
> and extract the uuid from that.
>
> And the UUID format you mention is different from the format used by
mdadm,
> which makes me like the patch even less.
>
>
> What problem are you trying to solve here?
>
> NeilBrown



