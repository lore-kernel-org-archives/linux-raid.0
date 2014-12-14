From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: Re: Lost raid 5 volume
Date: Sat, 13 Dec 2014 19:06:35 -0500
Message-ID: <CAB_L8sZUdZkLRPQXS+ANam=k4Tvjynkh8UzgL5WXE3qBwYUK6Q@mail.gmail.com>
References: <CADhQzuraHNZ1MaMw4OP0-3+vxRcB_TAN-_R2_eaTOQcEfUv8+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADhQzuraHNZ1MaMw4OP0-3+vxRcB_TAN-_R2_eaTOQcEfUv8+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil ." <neil.perrie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stop your raid with mdadm -S /dev/md0 or whatever your raid device name is.

Probably the safest thing to do is clone your drives with ddrescue.
You might also want to view your S.M.A.R.T. log with smarctl -a
/dev/sda or which ever is your device name.

After, what you'd need to start doing is taking a backup of mdadm
--examine /dev/sda1 or which ever partition is your partition used for
raid. This will give us info on you md superblock. Post this info and
from there we'll be able to see how everything is setup and have a
better idea of your current situation.

On Fri, Dec 12, 2014 at 7:48 PM, Neil . <neil.perrie@gmail.com> wrote:
> I am looking for some help in trying to recover a raid 5 volume. Is
> this the right place? What data should I provide to get the ball
> rolling?
>
> The back story is its 4 x 6tb drives in raid 5. Was created on a WD
> EX4 NAS box. The NAS reported 2 simultaneous drive failures on wake up
> from standby mode. On reboot both drives appear fine. No SMART errors
> etc but the raid 5 volume is gone.
>
> It's the second time the NAS box has lost data like this. Previous
> time it was a mix of 2 and 3 tb drives with a 6 tb raid 5 and a 1 tb
> mirror. mdadm on the nas is from 2006 (don't have the exact version to
> hand).
>
> I was thinking to put the drives into a PC, boot to a recent distro on
> usb stick and see if I can recover the data there. Then setup it up
> more or less permanently (and ditch the NAS). Not sure of the best way
> to proceed.
>
> I'd be really grateful for any assistance or guidance.
>
> Cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
