From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: LVM cannot stop/remove LV, cannot stop/delete dead RAID situation.
Date: Wed, 26 Aug 2009 13:20:45 +0200
Message-ID: <87d46i95yq.fsf@frosties.localdomain>
References: <4A93F912.5040900@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A93F912.5040900@mpstor.com> (Benjamin ESTRABAUD's message of
	"Tue, 25 Aug 2009 15:45:38 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Benjamin ESTRABAUD <be@mpstor.com> writes:

> Hi,
>
> I am having an issue with LVM and RAID in some failure cases:
>
> It seems that any operations on a LVM LV (lvchange, lvremove, etc..),
> require this LV's metadata to be readable.
>
> In case a LVM LV is setup ontop of a RAID 0, or a RAID 5 for instance,
> if two disks are lost from the RAID array, the array dies.
>
> Now that the array is dead, I would like to recreate a new RAID 0 or 5
> using the remaining alive disks and some new ones. For this reason,
> I'd like to stop the previous dead RAID using mdadm.
>
> However, because the LVM LV does still exists, it seems to have a
> handle on the dead RAID, as shon below:
>
>...
>
> The problem with the above is that because LVM depends on the RAID's
> good health to perform any operations, and the MD forbids to perform
> any operation should a handle be opened on itself, we cannot stop
> either the RAID or the LVM, unless the system is rebooted.
>
> Since rebooting works, but that I cannot afford to reboot in this
> case, I was wondering if anybody
> knew where to start looking to force the handle opened by LVM on the
> RAID to go away, maybe in the LVM admin programs (lvremove, lvchange)
> or in the dm driver itself?
>
> Thanks a million in advance for your advices.
>
> Ben - MPSTOR.

You can remove the lvm devices yourself:

man dmsetup

MfG
        Goswin
