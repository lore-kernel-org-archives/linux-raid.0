From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Error in rebuild of two "layered" md devices in container
Date: Wed, 1 Aug 2012 20:34:24 +0200
Message-ID: <CAGkViCEzijB_SRTYxGed5aFsEHFY2E7AxxS=UfLVpAUPSVUhEQ@mail.gmail.com>
References: <CAGkViCEBCMgPXbByGPe8MgTKsSkn1Dc=_XLgCCDCfSrEGwEs_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCEBCMgPXbByGPe8MgTKsSkn1Dc=_XLgCCDCfSrEGwEs_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Extra note:

as the mdadm -f command has to be addressed to a subarray, only this
one is going to be rebuild, even when other subarrays are depending on
this disk, as is in this case.

In the case below I failed the disk using mdadm -f /dev/md0 /dev/....

Albert

On 1 August 2012 19:52, Albert Pauw <albert.pauw@gmail.com> wrote:
> Hi Neil,
>
> found another bug.
>
> - Created a container with six disks
> - Created two md devices in it:
>
> mdadm -CR /dev/md0 -l 6 -n 6 -z 50M
> mdadm -CR /dev/md1 -l 5 -n 6 -z 50M
>
> The md devices are "layered" in the container across all disks.
>
> They both get build and are online.
>
> - Fail one disk, both md devices are affected
> - Remove disk
> - Clear superblock of removed disk
> - Add disk again (in essence, I just added a spare disk)
>
> Now comes the error:
>
> - md0 is rebuild
> - md1 is NOT rebuild
>
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md1 : active raid6 sde[6] sdg[5] sdf[4] sdd[2] sdc[1] sdb[0]
>       204800 blocks super external:/md127/1 level 6, 512k chunk,
> algorithm 10 [6/6] [UUUUUU]
>
> md0 : active raid5 sdb[6] sdg[5] sdf[4] sdd[2] sdc[1]
>       256000 blocks super external:/md127/0 level 5, 512k chunk,
> algorithm 2 [6/5] [UUU_UU]
>
> md127 : inactive sde[3](S) sdb[0](S) sdg[5](S) sdf[4](S) sdd[2](S) sdc[1](S)
>       196608 blocks super external:ddf
>
> unused devices: <none>
>
>  Physical Disks : 6
>       Number    RefNo      Size       Device      Type/State
>          0    cb5ea6c1   1015808K /dev/sdc        active/Online
>          1    a7f8ed2f   1015808K /dev/sdd        active/Online
>          2    f769a815   1015808K /dev/sdf        active/Online
>          3    025e6835   1015808K /dev/sdg        active/Online
>          4    b22e9e4d   1015808K /dev/sdb        active/Online
>          5    b4cccecc   1015808K /dev/sde        active/Online
>
>
> Albert
