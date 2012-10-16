From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: mdadm 3.2.5: Assemble doesn't scale correctly
Date: Tue, 16 Oct 2012 13:44:52 +0200
Message-ID: <507D48B4.305@profitbricks.com>
References: <507C3618.4030603@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <507C3618.4030603@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

Hi list,

we solved this by custom patches once again.

We added a parameter to "dev_open" to select whether we want "map_dev"
to be called or not.
In "create_mddev" from mdopen.c we trigger that "map_dev" isn't called
if the device name is /dev/mdX.

If such a device is already running is checked before in /proc/mdstat.
The SCSI tape driver has got the same major but as a char device - we
don't use it anyway. So there isn't much risk for us at least.

Because there could be cases we haven't thought of and the
implementation is possibly not the best way, it remains a custom fix and
I'm not sending any patches.

Btw.: The strace of the assembly dropped from >2000 to approx. 300 lines
on my PC.

Cheers,
Sebastian


On 15.10.2012 18:13, Sebastian Riemer wrote:
> Hi list,
>
> the mdadm 3.2.5 assemble command doesn't scale correctly.
>
> First, I've tested simple stuff with "strace" like this one:
>
> # mdadm -A /dev/md0 /dev/loop0 /dev/loop1
>
> This also scans imsm superblocks by reading files from "/sys/bus/pci".
> Let's set it explicitly to 1.2:
>
> # mdadm -A /dev/md0 -e 1.2 /dev/loop0 /dev/loop1
>
> This results in approx. 100 lines less strace output.
>
>
> But now the big performance killer:
>
> Assemble()->open_dev_excl()->dev_open("%d:%d")->map_dev()
>
> Why does this have to scan the whole "/dev" directory - not finding any
> device with the same/wanted major:minor? Isn't there a better method?
>
> It takes longer and longer the more devices are in /dev.
>
> Cheers,
> Sebastian
