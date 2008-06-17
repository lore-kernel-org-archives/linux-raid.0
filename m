From: Michal Soltys <soltys@ziu.info>
Subject: Re: Confused about UUID mounting and mirrors
Date: Tue, 17 Jun 2008 23:37:35 +0200
Message-ID: <48582E9F.4000508@ziu.info>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info> <4856DB4C.20905@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4856DB4C.20905@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@kmaclub.com wrote:
> 
> In /etc/fstab,  I have entries like this:
> 
> UUID=8e651838-38c1-4783-8bde-4174ec484d52 /     ext3    defaults  1 1
> UUID=aaeca70c-f0fe-470c-b631-87248648d275 /export xfs defaults,nobarrier 
> 1 2
> UUID=6e22c5b0-2874-4826-a871-ed733f8da643 swap swap    defaults   0 0
> UUID=323cd094-4cbe-4c3b-9096-366c05465e7c /export/services xfs defaults 1 2
> 
> 
> Do you have an example?  I am not sure I follow.
> 

Taken fragment from stock udev rules:

IMPORT{program}="vol_id --export $tempnode"

OPTIONS="link_priority=100"

ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*",
SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"

ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*",
SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"

- vol_id will export filesystem metadata, which udev will import and
make available for further rules in current uevent

- link_priority will prioritize uuid and label symlinks to the
filesystem found on md0, over existing or to-be-made symlinks
to mirror components. (actully - vol_id called for components will 
detect they are part of raid and return md's uuid along with USAGE=raid 
- so the link won't be even created in persistant storage rules).

- the rest will create appropriate symlinks

That's the general idea. Of coruse it's only a fragment. Check
60-persistent-storage.rules and 64-md-raid.rules from udev sources, to
see how things get done there.

E.g. in one fstab of mine (not uuids, the same idea though), there're:

/dev/disk/by-id/scsi-SATA_Maxtor_6Y120P0_Y32JMMQE-part1         /boot
ext2    defaults 0 0
/dev/disk/by-id/scsi-SATA_Maxtor_6Y120P0_Y32JMMQE-part2         swap
swap    defaults 0 0

> So what happens if someone sticks in a USB key and boots the machine. 
> The key bcomes sda, and each following drive shifts.  Is UDEV in this 
> case going to know to account for this?  The goal is to be able to 
> always find the filesystem regardless of what the disk name might be.
> 

That depends on the udev rules. With typical ones - your names would
shift, but symlinks created from /dev/disk/by-* directories would be proper.

You can even set sd{a,b,c,...} or any other names you want persistently
there, basing on the device's label, uuid or other traits - similary to
how network devices can be named persistently based on e.g. their mac
address. Still - with symlinks - there isn't much reason to.

When mdadm assembles your /dev/md0 - it usually looks for md's uuid
along other things (check your mdadm.conf) - so leaving /dev/md0 in
fstab should be perfectly fine. You can even name it /dev/grubboot - it
doesn't have to be md0.



