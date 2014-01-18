From: Martin Bruse <zondolfin@gmail.com>
Subject: Re: problems with block sizes in raid 5
Date: Sat, 18 Jan 2014 20:44:36 +0100
Message-ID: <CA+YGrSBjD3cE5dwOicKebgaz0UKwLDmtp_ZoUW4EeHh6XXweAQ@mail.gmail.com>
References: <CA+YGrSBw9CKZF7u3DZ_3+vvp1q3r2WzE4Kggc7vAX8dosQnJHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+YGrSBw9CKZF7u3DZ_3+vvp1q3r2WzE4Kggc7vAX8dosQnJHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And another interesting (and perhaps block size related) issue:

I have one of the old drives which seems to work (I can format it and
mount it etc), but when I try to add it to the array (to sync it up
and remove the new drives, and -hopefully- get a new array with 1024
block size), md says "Drive failure" the moment it starts to sync.

Can this be because the drive has a different block size (1024) than
the array (4096)? If so, how can the array even assemble with three
1024 block size drives and one 4096 block size?

My brain hurts,
Martin

On Sat, Jan 18, 2014 at 7:12 PM, Martin Bruse <zondolfin@gmail.com> wrote:
> Hello list, I have a problem that I have some small hope that you can
> help me with.
>
> I had a raid 5 array of 5 1TB drives, set up in an LVM group and then
> cryptomapped to an XFS filesystem.
>
> Now one of the drives failed, so I had to buy a new one.
>
> As I was also running out of space, I decided to buy 5 new 3TB drives instead.
>
> Last time I did this, I just set up a new array and then rsynced the
> entire filesystem over to the new array, but this time I figured I
> should be clever.
>
> So I started replacing one disk at a time with the new drives - each
> time waiting until they had synced up before removing the next old
> drive.
>
> This worked pretty well, until the array failed completely when I
> yanked a drive. I believe it was because another of the old drives
> hiccupped at the same time so the array stopped since I was missing
> two drives.
>
> Because I had my entire LVM + cryptomap + XFS setup running, I figured
> it was just faster to reboot than to take everything down to
> re-assemble with a --force to get it running again.
>
> So I rebooted, and did a manual reassemble with --force. And the array
> was up, and I ran my little setup-script that does the cryptomapping
> and mounting of the array.
>
> Here comes the problem: "mount" produced "mount: Function not implemented"
>
> I became slightly worried, and tried "xfs_check", which claimed I had
> a log file and refused to work.
>
> So I ran "xfs_repair", which said "xfs_repair: warning - cannot set
> blocksize 512 on block device /dev/mapper/data: Invalid argument"
>
> This made me start looking at the block sizes of the different drives.
> I ran "blockdevice --getbsz", and it became evident that the old
> drives had block size 1024, and the new ones 4096.
>
> This begs a few questions:
>
> 1) What block size will an md device have?
> 1.1) When it has 5 drives with block size 1024?
> 1.2) When it has 3 drives with block size 1024 and 2 with block size 4096?
>
> 2) If it gets a different block size in case 1.2), why didn't it
> happen until I rebooted? (The XFS mount seemed to work just fine, I
> accessed files without a hitch)
>
> 3) Is there a way to "force" a block size for an md device?
>
> In the end, of course, I am not expert enough to be sure that the
> block size is the problem, but this is the only lead I have. My weak
> hypothesis is "the md device kept the same 1024 block size (which is
> odd, since XFS seems to want 512?) until I rebooted, when it checked
> the block sizes of the component drives and chose the biggest one -
> which caused XFS to refuse to mount the drive".
>
> This makes me suspect that I must buy at least one new 1TB drive with
> a block size of 1024, sync into the array and restart the array
> without any 4096 block size drives in it.
>
> But before I do this, I thought I better ask some experts what they figured...
>
> best regards (and a panicky cry for help)
> Martin
