From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 17:15:59 +0000
Message-ID: <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stan@hardwarefreak.com
List-Id: linux-raid.ids

Okay,

I am nervous about losing 10+ years of personal data.  Your help would
be greatly appreciated!

I now have all four drives copied (with ddrescue) from the originals.
The new copies are connected to the system; the original drives are
not.  When attempting to boot from my normal boot drive, I see this
very early on in the boot process:

Booting...
errror: found two disks with the index 0 for RAID md/teramooch.
error: found two disks with the index 3 for RAID md/teramooch.

Later, once the dmesg material appears, I get to:

** WARNING: There appears to be one or more degraded RAID devices **

The system may have suffered a hardware fault, such as a disk drive
failure.  The root device may depend on the RAID devices being online.
One or more of the following RAID devices are degraded:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdi1[3](S) sdg1[0](S)
      3907021954 blocks super 1.2

unused devices: <none>
You may attempt to start the system anyway, or stop now and attempt
manual recovery operations.  To do this automatically in the future,
add "bootdegraded=true" to the kernel boot options.

If you choose to start the degraded RAID, the system may boot
normally, but performance may be degraded, and a further hardware
fault could result in permanent data loss.

If you abort now, you will be provided with a recovery shell.

Do you wish to start the degraded RAID [y/N]: Timed out
Gave up waiting for root device.  Common problems:
 - Boot args (cat /proc/cmdline)
   - Check rootdelay=  (did the system wait long enough?)
   - Check root= (did the system wait for the right device?)
 - Missing modules (cat /proc/modules: ls /dev)
ALERT!  /dev/mapper/teramooch-root does not exist.  Dropping to a shell!

BusyBox v1.18.5 (Ubuntu 1:1.18.5-1ubuntu4.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) _

I then rebooted and allowed the system rescue cd to boot.  cat
/proc/mdstat gives

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : inactive sda1[3](S) sdc1[0](S)
      3907021954 blocks super 1.2

unused devices: <none>

What should I do from here?

Thanks,
Dave
