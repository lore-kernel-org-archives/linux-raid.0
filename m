From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 09:05:57 -0800
Message-ID: <CAGRSmLufpZV5qYa-jq17n_MTWY0oc9yX4USoc0PZsb1LJheGcQ@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131119110110.396b2af3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

The mdadm 3.3 binary we've been using was compiled from source on a Debian
Wheezy 32-bit install, with the source downloaded from kernel.org

But also, this morning, I tried the same test with the 3.3 mdadm binary
taken from the Debian Jessie package here:

packages.debian.org slash jessie slash i386 slash mdadm slash download
(mdadm_3.3-2_i386.deb)

The results were the same, as this output shows:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdd4
mdadm: no RAID superblock on /dev/sdd3
mdadm: no RAID superblock on /dev/sdd2
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: cannot open device /dev/sr1: No medium found
mdadm: cannot open device /dev/sr0: No medium found
mdadm: no RAID superblock on /dev/sda11
mdadm: no RAID superblock on /dev/sda10
mdadm: no RAID superblock on /dev/sda9
mdadm: no RAID superblock on /dev/sda8
mdadm: no RAID superblock on /dev/sda7
mdadm: no RAID superblock on /dev/sda6
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda4
mdadm: no RAID superblock on /dev/sda3
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sdc is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sdc2 to /dev/md/imsm0 as -1
mdadm: failed to add /dev/sdc to /dev/md/imsm0: Device or resource busy
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/RAID0
mdadm: looking in container /dev/md/imsm0
mdadm: found match on member /md127/0 in /dev/md/imsm0
mdadm: Started /dev/md/RAID0 with 2 devices

I ran strace on this version with this command:
strace -o mdadm33trace.txt mdadm --assemble --scan --no-degraded

Here's a link to the strace output file:
www.dropbox.com slash s slash l5tcgu8zvjn7eb7 slash mdadm33trace.txt

On Mon, Nov 18, 2013 at 4:01 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 18 Nov 2013 15:13:58 -0800 "David F." <df7729@gmail.com> wrote:
>
>
>> output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
> ...
>> mdadm: no RAID superblock on /dev/sdc2
>
>
>
>>
>> output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
>> note using /dev/sdc2, not /dev/sdc):
> .....
>> mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
>
> So there is the problem.  mdadm 3.2.6 sees no RAID superblock on sdc2, while
> mdadm 3.3 does (but should not).
>
>
> However that code hasn't changed!
>
> load_super_imsm() still starts with:
>
>
>         if (test_partition(fd))
>                 /* IMSM not allowed on partitions */
>                 return 1;
>
>
> and test_partition hasn't changed since it was written in April 2010 for
> mdadm 3.1.3.
>
> So I'm quite perplexed.
>
> Is your mdadm-3.3 compiled from source or provided by a distro?
>
> Can you run the "mdadm --assemble" under strace and post the result?
>
>   strace -o /tmp/some-file mdadm --assemble --scan ......
>
> Thanks,
> NeilBrown
