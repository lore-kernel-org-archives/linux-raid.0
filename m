From: Haakon Alstadheim <hakon.alstadheim@gmail.com>
Subject: Re: Interrupted reshape -- mangled backup ?
Date: Thu, 18 Oct 2012 16:08:10 +0200
Message-ID: <50800D4A.8090704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(I'm copying to the list as well)

On 18. okt. 2012 00:33, NeilBrown wrote:
> On Wed, 17 Oct 2012 23:34:26 +0200 Haakon Alstadheim
> <hakon.alstadheim@gmail.com>  wrote:
>
>> I have a Raid5 array with 4 devices that I wanted to see if I could get
>> a better performance out of, so i tried changing the chunk size from 64K
>> to something bigger. (famous last words) .  I got into some other
>> trouble and thought I needed a reboot. On reboot I several times managed
>> to mount and specify the device with my backup file during initramfs,
>> but the reshape stopped every time once the system was at initialized.
> So worst-case you can do that again, but insert a "sleep 365d" immediately
> after the "mdadm --assemble" is run, so the system never completely
> initialises.  Then just wait for the reshape to finish.
Yes, well I need to keep my mail-server running :-). Couple of hours 
down-time each night is acceptable though.

>
> When mdadm assembles and array that needs to keep growing it will for a
> background process to continue monitoring the reshape process.  Presumably
> that background process is getting killed.  I don't know why.
>
>> This is under debian sqeeze with a 3.2.0-0.bpo.3-686-pae kernel from
>> backports. I installed mdadm from backports to get the latest version of
>> that as well, and tried rebooting with --freeze-reshape. Suspect that I
>> mixed up my initrd.img-files and started without --freeze-reshape the
>> first time after installing the new mdadm. Now mdadm says it can not
>> find a backup in my backup file. Opening up the backup in emacs, it
>> seems to contain only NULs. Can't be right, can it? I have been mounting
>> the backup under a directory under /dev/, on the assumption that the
>> mount wold survive past the initramfs stage.
> The backup file could certainly contain lots of nuls, but it shouldn't be
> *all* nulls.
I checked again, isearch-forward-regexp for [^^@] in emacs gives no 
hits. ^@ is the emacs way of displaying ASCII-NUL
>    At least there should be a header at the start which describes
> which area of the device is contained in the backup.
>
> You can continue without a backup.  You still need to specify a backup file,
> but if you add "--invalid-backup", it will continue even if the backup file
> doesn't contain anything useful.
Thanks! device is now running again. These switches are hard to google 
after. Especially when you are a bit stressed :-)
> If the machine was shutdown by a crash during reshape you might suffer
> corruption.  If it was a clean shutdown you won't.

No corruption yet, (last reboot without fsck though).

>
> --freeze-reshape is intended to be the way to handle this, with
>     --grow --continue
> once you are fully up and running, but I don't think that works correctly for
> 'native' metadata yet - it was implemented with IMSM metadata in mind.
>
> NeilBrown
You are right, mdadm segfaults when I try to do mdadm --grow --continue 
--backup-file=/dev/bak/md1-backup /dev/md1.

We'll se tonight at 04:15 whether my custom initramfs script can make 
some progress on the reshape, and continue booting without messing up 
the backup-file.

In my initramfs script, should I do the following ? :
1. Start the array
2. Sleep a while
3. Stop the array
4. Start with --freeze-reshape
5. Continue boot

... or is it just as well to live with the timestamps getting out of 
sync when the reshape dies? I.e skip the stop&restart bit ?


