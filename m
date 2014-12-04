From: "Matthew M. Dean" <fireculex@gmail.com>
Subject: Re: pretty unstable raid 5 now
Date: Thu, 4 Dec 2014 03:10:46 -0800
Message-ID: <CAPRzDfm457r+DEB1Xw5ufRxr66JHnb7FXVok3ZTYtOU1oMwYZA@mail.gmail.com>
References: <CAPRzDfn33EBkci823=zw=6b3jnf-0YMr1YTU_j7RQ5qseu_fvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPRzDfn33EBkci823=zw=6b3jnf-0YMr1YTU_j7RQ5qseu_fvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

md/raid:md0: Disk failure on loop3, disabling device.
mdadm --manage /dev/md0 --re-add /dev/loop3
mdadm: Cannot open /dev/loop3: Device or resource busy

# losetup -d /dev/loop3

 # losetup -a
/dev/loop1: 0 /media/live1/node1.img
/dev/loop2: 0 /media/live2/node2.img
/dev/loop3: 0 /media/live3/node3.img

what?

# lsof | grep "loop3"
loop3      2577   root  cwd       DIR       0,15        0        160 /
loop3      2577   root  rtd       DIR       0,15        0        160 /
loop3      2577   root  txt   unknown
/proc/2577/exe

# ps | grep "2577"
 2577 root         0 SW<  [loop3]

# reboot
# mdadm --manage /dev/md0 --re-add /dev/loop3
mdadm: re-added /dev/loop3
root@OpenWrt:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 loop3[3] loop1[0] loop2[1]
      3878157312 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  0.0% (2596/1939078656)
finish=24783.6min speed=1298K/sec
      bitmap: 5/15 pages [20KB], 65536KB chunk

WHAT?

On Wed, Dec 3, 2014 at 6:08 PM, Matthew M. Dean <fireculex@gmail.com> wrote:
> So I've been running a raid 5 using an openwrt box with 3 loop files
> and lvm. All was well for over a year. Now /dev/loop3 keeps dropping
> from the raid
>
> The first time it dropped was due to the network drive actually
> locking up, it tried to start with only 1 drive and failed. I had to
> --force the loop files to start, which 2 of them actually did. I could
> no longer --re-add the drive.
>
> Using --add did add the drive to the raid but the sync started at 0%
> so have to wait for it to rebuild. 11mb/sec takes a while on a 1.5
> terabyte array.
>
> after 82% sync the router locked up I think to a oom condition, 128mb
> only. /dev/loop3 was dropped from the array again. I was able to
> --re-add. 0% SYNC AGAIN. ~30 hours wasted. This has never happened.
>
> What has changed?
>
> I upgraded from a 3.10 kernel to 3.14 and from mdadm 3.2.6 to 3.3.2
>
> Aren't bitmap's supposed to fix this? Are they useless now?
