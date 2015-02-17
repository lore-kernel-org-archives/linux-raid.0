From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data
 loss)
Date: Wed, 18 Feb 2015 09:47:56 +1100
Message-ID: <54E3C51C.2080106@websitemanagers.com.au>
References: <loom.20150214T222329-324@post.gmane.org>	<20150216142845.0d50207c@notabene.brown>	<loom.20150216T124230-883@post.gmane.org>	<54E1EDEA.1030503@turmel.org>	<loom.20150216T165111-551@post.gmane.org>	<54E226B5.1080500@turmel.org>	<loom.20150216T183419-387@post.gmane.org>	<20150217104906.62d36c62@notabene.brown>	<loom.20150217T080345-764@post.gmane.org> <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/02/15 06:33, Chris Murphy wrote:
> It's not just mdadm. It likewise affects Btrfs, ZFS, and LVM.
>
> Also, there's a lack of granularity with linux command timer and SCT
> ERC applying only to the entire block device, not partitions. So
> there's a problem for mixed use cases. For example, two drives, each
> with two partitions. sda1 and sdb1 are raid0, and sda2 and sdb2 are
> raid1. What's the proper configuration for SCT ERC and the SCSI
> command timer?

Umm, actually I don't know enough to disagree, but I'll ask some 
questions which probably shows both the assumptions I've made, and might 
help others understand the issue better.

If we enable SCT ERC on every drive that supports it, and we are using 
the drive (only) in a RAID0/linear array then what is the downside? As I 
understand it, the drive will no longer try for > 120sec to recover the 
data stored in the "bad" sector, and instead return an unreadable error 
message in a short amount of time (well below 30 seconds) which means 
the driver will be able to return a read error to the application (or FS 
or MD) and the system as a whole will carry on. If we didn't enable SCT 
ERC, then the entire drive would vanish, (because the timeout wasn't 
changed for the driver) and the current read and every future read/write 
will all fail, and the system will probably crash (well, depending on 
the application, FS layout, etc).

So, IMHO, it seems that by default, every SCT ERC capable drive should 
have this enabled by default. As a part of error recovery (ie, crap that 
really important data stored on those few unreadable sectors) the user 
could manually disable SCT ERC and re-attempt to request the data from 
the drive (eg, during dd_rescue or similar).


Secondly, changing the timeout for those drives that don't support SCT 
ERC, again, it is fairly similar to above, we get the error from the 
drive before the timeout, except we will avoid the only possible 
downside above (failing to read a very unlikely but possible to read 
sector). Again, we will avoid dropping the entire drive, even if all 
operations on this drive will stop for a longer period of time, it is 
probably better than stopping permanently.

So, IMHO, every non SCT ERC capable drive should have the timeout 
extended to 120s/180s or whatever the appropriate time is that (most) 
drives will respond within. Leaving only the most extremely brain dead 
drives which we simply ridicule on the list and anywhere and everywhere 
possible to ensure nobody will ever buy them (or the manufacturer will 
fix the problems).


Of course, quite possible I've totally over simplified this, and don't 
understand the other repercussions?

> *shrug* I don't think the automatic udev configuration idea is fail
> safe. It sounds too easy for it to automatically cause a
> misconfiguration. And it also doesn't at all solve the problem that
> there's next to no error reporting to user space. smartd does, but
> it's narrow in scope and entirely defers to the hard drive's
> self-assessment. There's all sorts of problems that aren't in the
> domain of SMART that get reported in dmesg, but there's no method for
> gnome-shell or KDE or any DE or even send an email to a sysadmin, as
> an early warning. Instead, all too often it's "WTF XFS just corrupted
> itself!" meanwhile the real problem has been happening for a week,
> dmesg/journal is full of errors indicating the nature of those
> problems, but nothing bothered to inform a human being until the file
> system face planted.

Just because the solution doesn't solve the entire problem, it does 
solve a part of the problem, so IMHO, better to solve this part of the 
problem, and then discuss/try to find a solution to the rest of the 
problem. Unless you have a suggestion which can solve both parts of the 
problem? I suppose that a "good" sysadmin should install some sort of 
log monitoring software which will alert them to issues, whether that is 
via some desktop application/popup or email or something else. The 
problem is that most of these issues come from "home" users who will 
never setup anything like "log file monitoring" or raid scrubs, or 
anything else, so if we do decide upon a generic solution that will work 
for almost everybody, then we will still need to rely on the distro 
maintainers to implement the solution.

PS, I suppose this is one of the "hide the gory details that nobody 
understands" balancing with "provide the information to the user so they 
can do something about it". One more generic consideration would be to 
have the kernel identify which messages are purely informational/debug 
and which are errors. Normal syslog has support for many different 
levels, but AFAIK, all kernel messages end up in the same basket.

eg (plugging in and removing a USB drive generated the following log 
entries as seen from "dmesg":
[614977.802828] usb 3-3: new high-speed USB device number 5 using xhci_hcd
[614977.822724] usb 3-3: New USB device found, idVendor=0951, idProduct=1665
[614977.822729] usb 3-3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[614977.822732] usb 3-3: Product: DataTraveler 2.0
[614977.822735] usb 3-3: Manufacturer: Kingston
[614977.822737] usb 3-3: SerialNumber: 60A44C413CCBFE40AB4FFB3E
[614977.822899] usb 3-3: ep 0x81 - rounding interval to 128 microframes, 
ep desc says 255 microframes
[614977.822905] usb 3-3: ep 0x2 - rounding interval to 128 microframes, 
ep desc says 255 microframes
[614977.836547] usb-storage 3-3:1.0: USB Mass Storage device detected
[614977.836734] scsi6 : usb-storage 3-3:1.0
[614977.836819] usbcore: registered new interface driver usb-storage
[614978.854080] scsi 6:0:0:0: Direct-Access     Kingston DataTraveler 
2.0 1.00 PQ: 0 ANSI: 4
[614978.854493] sd 6:0:0:0: Attached scsi generic sg2 type 0
[614978.854658] sd 6:0:0:0: [sdb] 15131636 512-byte logical blocks: 
(7.74 GB/7.21 GiB)
[614978.854884] sd 6:0:0:0: [sdb] Write Protect is off
[614978.854888] sd 6:0:0:0: [sdb] Mode Sense: 45 00 00 00
[614978.855085] sd 6:0:0:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[614978.860015]  sdb: sdb1
[614978.860864] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[614979.061474] FAT-fs (sdb1): Volume was not properly unmounted. Some 
data may be corrupt. Please run fsck.
[615347.862058] usb 3-3: reset high-speed USB device number 5 using xhci_hcd
[615347.862111] usb 3-3: Device not responding to set address.
[615348.065856] usb 3-3: Device not responding to set address.
[615348.269944] usb 3-3: device not accepting address 5, error -71
[615348.326429] usb 3-3: USB disconnect, device number 5
[615348.334730] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88011b1b2600
[615348.334744] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88011b1b2640


Of the above, I would suggest most of that is "info" while the following 
lines might be warnings:
[614979.061474] FAT-fs (sdb1): Volume was not properly unmounted. Some 
data may be corrupt. Please run fsck.
These might be error or critical:
[615347.862058] usb 3-3: reset high-speed USB device number 5 using xhci_hcd
[615347.862111] usb 3-3: Device not responding to set address.
[615348.065856] usb 3-3: Device not responding to set address.
[615348.269944] usb 3-3: device not accepting address 5, error -71

Of course, this will rely on every driver maintainer to make a decision 
on just how important each line that they log may be.

Just my thoughts, hopefully it will be useful.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
