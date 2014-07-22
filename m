From: Ron Leach <ronleach@tesco.net>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 14:21:18 +0100
Message-ID: <53CE654E.2000800@tesco.net>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE592B.6030706@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 22/07/2014 13:29, Phil Turmel wrote:
>
> there's a copy of mdadm.conf in your initramfs that governs what is
> assembled in the early boot phase.  Strictly speaking, only the arrays
> needed to get to your root filesystem *must* be assembled then, but all
> the distros I've tried assemble everything then.  The "mkinitrd" or
> "update-initramfs" utility will copy your mdadm.conf into the initramfs.

Noted.

[...]

> If you want your boot process to be as robust as possible, omit the
> 'level=' and 'num-devices=' selectors in the ARRAY clauses and identify
> your filesystems in fstab with LABEL= or UUID= taken from the output of
> "blkid".  (Not the array UUIDs.)
>

I don't think I quite follow this.  I worry that I'll make the 
incorrect change and then not be able to boot or then repair my mistake.

Here's the output of blkid (lines are wrapping, sorry)

D5s2:/# blkid
/dev/sda1: UUID="eb3b45e8-e1d7-3b1a-6304-2e90fced6612" 
TYPE="linux_raid_member"
/dev/sda2: UUID="93a0b403-18aa-4e20-f77b-014225a55090" 
TYPE="linux_raid_member"
/dev/sda3: UUID="99104b71-9dd6-cf88-e1a0-594857032dd7" 
TYPE="linux_raid_member"
/dev/sda4: UUID="5dbd5605-1d61-cbaa-ac5c-64ee5356e8a9" 
TYPE="linux_raid_member"
/dev/sda5: TYPE="swap"
/dev/sda6: UUID="725cfde4-114f-ef9a-4ed1-ccad18d72d44" 
TYPE="linux_raid_member"
/dev/sda7: UUID="5bad4c7c-7806-96f4-e201-a2f57bba85d7" 
TYPE="linux_raid_member"
/dev/sda8: UUID="94171c8e-c47d-18a8-c073-121cf9f222fe" 
TYPE="linux_raid_member"
/dev/sdb1: UUID="eb3b45e8-e1d7-3b1a-6304-2e90fced6612" 
TYPE="linux_raid_member"
/dev/sdb2: UUID="93a0b403-18aa-4e20-f77b-014225a55090" 
TYPE="linux_raid_member"
/dev/sdb3: UUID="99104b71-9dd6-cf88-e1a0-594857032dd7" 
TYPE="linux_raid_member"
/dev/sdb4: UUID="5dbd5605-1d61-cbaa-ac5c-64ee5356e8a9" 
TYPE="linux_raid_member"
/dev/sdb5: TYPE="swap"
/dev/sdb6: UUID="725cfde4-114f-ef9a-4ed1-ccad18d72d44" 
TYPE="linux_raid_member"
/dev/sdb7: UUID="5bad4c7c-7806-96f4-e201-a2f57bba85d7" 
TYPE="linux_raid_member"
/dev/sdb8: UUID="94171c8e-c47d-18a8-c073-121cf9f222fe" 
TYPE="linux_raid_member"
/dev/md0: LABEL="boot" UUID="67c165a8-020a-4931-98d4-21b3dcb5d53c" 
TYPE="ext2"
/dev/md1: LABEL="slash" UUID="6fa78f26-4ca9-4e41-909d-ac4c8877f317" 
TYPE="xfs"
/dev/md2: LABEL="usr" UUID="9ba54810-c299-424c-b312-e13325e00e4f" 
TYPE="xfs"
/dev/md3: LABEL="var" UUID="7d4918f3-eb9e-493a-a106-b9c21eff412c" 
TYPE="xfs"
/dev/md4: LABEL="tmp" UUID="cf09135c-cc46-424f-9f0b-a737cfacf27b" 
TYPE="xfs"
/dev/md6: LABEL="Data97" UUID="a2e22925-f763-4b70-9559-d959b1eb9329" 
TYPE="xfs"
D5s2:/#

My first query is, /dev/md5 is missing from this; should it be, at 
this stage?

You mentioned not to use the array uuids, but aren't these uuids the 
only uuids equating to the md device?  The other ids listed here by 
blkid are the individual partitions on the underlying drives.


> You can start by using "mdadm -Es>>/etc/mdadm/mdadm.conf", deleting the
> unnecessary parts, and adjusting array numbers to suit your preferences.
>

D5s2:/# mdadm -Es>>/etc/mdadm/mdadm.conf2
D5s2:/# cat /etc/mdadm/mdadm.conf2
ARRAY /dev/md0 UUID=eb3b45e8:e1d73b1a:63042e90:fced6612
ARRAY /dev/md1 UUID=93a0b403:18aa4e20:f77b0142:25a55090
ARRAY /dev/md2 UUID=99104b71:9dd6cf88:e1a05948:57032dd7
ARRAY /dev/md3 UUID=5dbd5605:1d61cbaa:ac5c64ee:5356e8a9
ARRAY /dev/md4 UUID=725cfde4:114fef9a:4ed1ccad:18d72d44
ARRAY /dev/md126 UUID=5bad4c7c:780696f4:e201a2f5:7bba85d7
ARRAY /dev/md6 UUID=94171c8e:c47d18a8:c073121c:f9f222fe
D5s2:/#

There's /dev/md126, again.  This isn't the proper 'conf' file yet; is 
it safe to change /dev/md126 to /dev/md5, when overwriting the proper 
'conf' file?

Ah, it's dawning.  Did you mean that these uuids, from the -Es 
command, and which are labelled ARRAY, are 'not' the uuids to use in 
fstab, but the other uuids from blkid, and labelled UUID, are 'ok' to 
use in fstab?  I think I've got it.

So I've got to

(i) change fstab to have blkid's listed UUIDs,
No, there's a problem.  I don't have a UUID for /dev/md5, for my /home 
mount in fstab.

(ii) change mdadm.conf to have this new set of ARRAY statements (from 
-Es command) instead of the existing set in mdadm.conf, with md126 
replaced by md5, and

(iii) get this mdadm.conf copied into initramfs.

I'm not confident about fstab, because of the missing /dev/md5 
identifier.  So I haven't made any changes, yet.

Phil, thanks for the reply, and advice; sorry to still seem so cautious,

regards, Ron

