From: Phil Turmel <philip@turmel.org>
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best
 of both worlds?
Date: Tue, 30 Nov 2010 08:13:00 -0500
Message-ID: <4CF4F85C.1020806@turmel.org>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>	<4CF3F7A0.2080108@rjl.com>	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>	<4CF4A472.20107@rjl.com> <AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Nataraj <incoming-centos@rjl.com>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

Hi Hans, (?)

On 11/30/2010 02:34 AM, hansbkk@gmail.com wrote:
> On Tue, Nov 30, 2010 at 2:14 PM, Nataraj <incoming-centos@rjl.com> wrote:
>>> TopRAID1's LVM is likely to be running over a RAID6 set , so I'm not
>>> depending on the TopRAID mirroring for reliability, just using it for
>>> the above volume cloning.
>>
>> Your raid 1 backups won't mirror any snapshots of your LV's unless you
>> specifically setup mirroring of the snapshots after they exist.
> 
> Ah, getting clearer to me, I was thinking I'd be mirroring the LV
> itself, but you're right, taking a snapshot and mirroring that is a
> much better idea.

I think you are making this overly complex, insisting on a RAID1 operation to backup from on filer to the other.  Consider having each disk on filer #2 configured as a single LVM PV/VG, so it can stand alone in a rotation.  The try the alternate below.

> So here's a summary of steps, please confirm:
>   - create a snapshot of a given volume

Here's where you are over-complicating things:
>   - create a new RAID1 mdN between that and a physical partition (blank?)
>   - let that get sync'd up
>   - break the RAID (fail the partition?), remove the drive

As an alternate, with simpler recovery semantics:
  Create matching LV on non-RAID PV/VG on filer #2
  dd + netcat + dd or other technique to dup the snapshot on filer #1 to filer #2

>   - delete the snapshot

Now, you have a single disk in your backup set that can be mounted on either filer, and either copied back into service, or in an emergency, used directly (live) in filer #1.

This approach also gives you the *option* to implement the backup transfer with file system conversions, compression, free space removal, or any other administrative adjustments you need.  A RAID mirror can only duplicate the raw block device.

HTH,

Phil
