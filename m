From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 09:37:21 -0800
Message-ID: <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobx <net@tobx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

What the version of mdadm in the test? Could you please help get the output of:

mdadm -E /dev/sd[bcde]1

Thanks,
Song




On Wed, Nov 8, 2017 at 1:37 AM, Tobx <net@tobx.de> wrote:
> Hello,
>
> I try to get a RAID 5 array to assemble at boot with mdadm:
>
> # mdadm --create /dev/md/test --level=5 --raid-devices=3 --write-journal=/dev/sde1 /dev/sd[bcd]1
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/test started.
> # /usr/share/mdadm/mkconf > /etc/mdadm/mdadm.conf
> # update-initramfs -u -k all
> update-initramfs: Generating /boot/initrd.img-4.9.0-4-amd64
> # reboot
>
> After the reboot:
>
> # mdadm --detail /dev/md/test
> mdadm: cannot open /dev/md/test: No such file or directory
>
> This can easily be corrected with:
>
> # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> # mdadm --assemble --scan
> mdadm: /dev/md/test has been started with 3 drives and 1 journal.
>
> The same works as expected when leaving out the journal option "--write-journal=/dev/sde1".
>
> The same issue occurs without a mdadm.conf file:
>
> # rm /etc/mdadm/mdadm.conf
> # update-initramfs -u -k all
> update-initramfs: Generating /boot/initrd.img-4.9.0-4-amd64
>
> It does not work with the journal option, but it works without.
>
> Options in /etc/default/mdadm:
>
> AUTOCHECK=true
> START_DAEMON=true
> DAEMON_OPTIONS="--syslog"
> VERBOSE=false
>
> Options in /etc/mdadm/mdadm.conf (if used):
>
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md/test  metadata=1.2 UUID=4f0448f6:fee2638c:a1c1b547:20358980 name=debian:test
>    spares=1
>
> I tried this with Debian Stretch (4.9.0-4), Debian Stretch (4.13.0-0) and Ubuntu 17.10 (4.13.0-16).
>
> I can hardly find any information about the journal option, am I missing something?
>
> Cheers,
> Tobi--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
