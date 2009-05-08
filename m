From: "NeilBrown" <neilb@suse.de>
Subject: Re: Hot spare rebuild did not start.
Date: Fri, 8 May 2009 22:24:29 +1000 (EST)
Message-ID: <8856b0d15faf0eb1c7b86b25a82c64f9.squirrel@neil.brown.name>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC027F1D36@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D76E016F4A2A749A1EB1A3FD83E22BC027F1D36@uk-email.terastack.bluearc.c
     om>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 8, 2009 9:13 pm, Simon Jackson wrote:
>
> I replaced a drive in a RAID 1 system, prepared the drive for use in my
> RAID 1 setup and then added the member partitions to the RAID devices.
> The recover copies started as I expected.  Howerver, the system reset
> and rebooted whilst the recovery was occurring.
>
> After the reboot 2 of the partitions completed recovery, but the third
> (which was a swap partition) seems to have failed to recover.
>
> The second device is showing as a hot spare, but no recovery started and
> the device remains degraded. See output of /proc/mdstat below:
>
> Any ideas why this has happened?
>
> Running Debian 2.6.26-1
>
>
> merc:~# cat /proc/mdstat
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6]
> [raid5][raid4][raid10]
>
> md2 : active (auto-read-only) raid1 sda2[0] sdb2[2](S)
               ^^^^^^^^^^^^^^^^
I should document that better.

>
>       7823552 blocks [2/1] [U_]
>

As soon as something writes to /dev/md2, the recovery will
start.  Or you can kick-start it with
   mdadm --readwrite /dev/md2

NeilBrown




>
>
> md0 : active raid1 sda5[0] sdb5[1]
>
>       15631104 blocks [2/2] [UU]
>
>
>
> md1 : active raid1 sda6[0] sdb6[1]
>
>       49994176 blocks [2/2] [UU]
>
>
>
> unused devices: <none>
>
>
>
> thanks Simon.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

