From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: progress, but... - re. fixing LVM/md snafu
Date: Sun, 05 Apr 2009 23:44:00 +0200
Message-ID: <87eiw6bwtb.fsf@frosties.localdomain>
References: <49D8E4EE.3020703@traversetechnologies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D8E4EE.3020703@traversetechnologies.com> (Miles Fidelman's
	message of "Sun, 05 Apr 2009 13:05:50 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@traversetechnologies.com>
Cc: debian-user <debian-user@lists.debian.org>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

Miles Fidelman <mfidelman@traversetechnologies.com> writes:

> Hello again Folks,
>
> So.. I'm getting closer to fixing this messed up machine.
>
> Where things stand:
>
> I have root defined as an LVM2 LV, that should use /dev/md2 as it's PV.
> /dev/md2 in turn is a RAID1 array built from /dev/sda3 /dev/sdb3 and
> /dev/sdc3
>
> Instead, LVM is reporting: "Found duplicate PV
> 2ppSS2q0kO3t0tuf8t6S19qY3ypWBOxF: using /dev/sdb3 not /dev/sda3"
> and the /dev/md2 is reporting itself as inactive (cat /proc/mdstat)
> and active,degraded (mdadm --detail)

So you didn't tell lvm.conf to ignore raid component devices or the
detection fails. Worst case exclude sd?3 manualy.

After that a reboot should fix it.

MfG
        Goswin
