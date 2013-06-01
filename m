From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Sat, 01 Jun 2013 19:30:05 -0400
Message-ID: <51AA83FD.8080500@turmel.org>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Finley <debenbain@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Chris,

On 06/01/2013 02:23 AM, Chris Finley wrote:
> I am trying to recover a failed Raid 5 array by following the guide at
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

Stop.  Report the *critical* details of your setup.  At least:

1) "mdadm -E /dev/sdXX" for every member device of the raid.
2) "dmesg" or suitable portions of syslog, showing the last attempted
assembly, the first failed assembly, the failure events that started
your saga, and the last pre-failure assembly.
3) an account of all "mdadm" commands you've already used and their results.
4) an account of any other operations you've performed that might have
written to the member disks.

> Things go fine until I get to the command under "Setup the loop-device
> and the overlay device:"
> 
> parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f --show --
> overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}'
> ::: $DEVICES
> 
> This command gets me:
> device-mapper: reload ioctl failed: Device or resource busy
> Command failed
> device-mapper: reload ioctl failed: Device or resource busy
> Command failed
> device-mapper: reload ioctl failed: Device or resource busy
> Command failed
> device-mapper: reload ioctl failed: Device or resource busy
> Command failed

Your array is probably still partially assembled.  The wiki is lame.
This mailing list is the right place to get help.  (I'm rather biased
against wikis for this sort of thing, but that's off-topic.)

> The drives are not mounted. I am booting to a system on sda. I tried
> this in single-user mode with the same result. I tried searching for
> dmsetup help without luck.
> 
> Any advise on the cause of this error would be greatly appreciated.
> 
> The overlays are created in my current directory at 2.1TB each:
> -rw-r--r-- 1 root root 2.1T May 30 21:23 overlay-sdb1
> -rw-r--r-- 1 root root 2.1T May 30 21:23 overlay-sdc1
> -rw-r--r-- 1 root root 2.1T May 30 21:23 overlay-sdd1
> -rw-r--r-- 1 root root 2.1T May 30 21:23 overlay-sde1
> 
> The loop devices appear to be created:
> root@mythserver:~# losetup -a
> /dev/loop0: [0807]:58851784 (/root/overlay-sdb1)
> /dev/loop1: [0807]:58851786 (/root/overlay-sdc1)
> /dev/loop2: [0807]:58851787 (/root/overlay-sdd1)
> /dev/loop3: [0807]:58851792 (/root/overlay-sde1)
> 
> These are the entries that are piped into 'dmsetup create {/}':
> 0 3907024002 snapshot /dev/sdb1 /dev/loop0 P 8
> 0 3907024002 snapshot /dev/sdc1 /dev/loop1 P 8
> 0 3907024002 snapshot /dev/sdd1 /dev/loop2 P 8
> 0 3907024002 snapshot /dev/sde1 /dev/loop3 P 8
> 
> Nothing has been created in /dev/mapper/
> root@mythserver:~# l /dev/mapper/
> total 0
> crw------- 1 root root 10, 236 May 30 23:55 control

These exercises to make overlays are rarely needed, and don't appear to
have been created as intended.

Please just round up the data requested and report back.  (Paste text
inline, or use plain text attachments, please.)

We may want more data later (like smartctl reports), but items #1-#4 are
needed now.

Phil

