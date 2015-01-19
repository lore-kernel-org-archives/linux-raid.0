From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: kernel refuses devices mdadm -E accepts
Date: Mon, 19 Jan 2015 17:52:49 -0600
Message-ID: <CAAMCDed18UGs42LD6CCWOFEYDe16xFq4GqnM1Lxhp0YHEgLFXQ@mail.gmail.com>
References: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wesley W. Terpstra" <wesley@terpstra.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

cat /proc/mdstat

if the device is in use mdadm -E will work but you cannot create a
device because one already has it.

On Mon, Jan 19, 2015 at 5:01 PM, Wesley W. Terpstra <wesley@terpstra.ca> wrote:
> I have a raid5 array for which every disk, when examined with "mdadm
> -E /dev/sd[abcd]4" shows a Version: 1.2 superblock with a valid
> checksum.
>
> However, when I try:
> mdadm -A /dev/md/backing /dev/sd[abcd]4
> mdadm says:
> mdadm: failed to add /dev/sdc4 to /dev/md/backing: Invalid argument
> mdadm: failed to add /dev/sdb4 to /dev/md/backing: Invalid argument
> mdadm: failed to add /dev/sda4 to /dev/md/backing: Invalid argument
> mdadm: failed to add /dev/sdd4 to /dev/md/backing: Invalid argument
> mdadm: /dev/md/backing assembled from 0 drives - need all 4 to start
> it (use --run to insist)
> The kernel says:
> md: sdc4 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
> md: sdb4 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
> md: sda4 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
> md: sdd4 does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22
>
> I was in the middle of a reshape of this 4-disk raid5 when something
> rebooted the computer. The system seems otherwise fine, and I suspect
> someone in the house.
>
> What is the correct next step? Should I try --run ? I would obviously
> prefer not to lose the data on this array. I expect that the reshape
> was NOT complete, so just recreating the array will probably corrupt
> its contents.
>
> Kernel version 3.17.8 and mdadm version 3.3.2.
>
> Thanks for any help. If I lose this array, I am going to face a lot of grief...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
