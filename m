From: hansbkk@gmail.com
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best of
 both worlds?
Date: Tue, 30 Nov 2010 22:39:16 +0700
Message-ID: <AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>
	<4CF3F7A0.2080108@rjl.com>
	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>
	<4CF4A472.20107@rjl.com>
	<AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
	<4CF4F85C.1020806@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF4F85C.1020806@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Nataraj <incoming-centos@rjl.com>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 8:13 PM, Phil Turmel <philip@turmel.org> wrote:
> I think you are making this overly complex, insisting on a RAID1 operation to backup from on filer to the other.  Consider having each disk on filer #2 configured as a single LVM PV/VG, so it can stand alone in a rotation.  The try the alternate below.

<snip>

> As an alternate, with simpler recovery semantics:
>  Create matching LV on non-RAID PV/VG on filer #2
>  dd + netcat + dd or other technique to dup the snapshot on filer #1 to filer #2
>
>>   - delete the snapshot

Thanks Phil, and yes I do tend to complicate things during a
learning/planning stage, then when I get to implementation reality
tends to force simplification :)

Perhaps I miscommunicated, but your suggestion misses a couple of factors:
  - this process is (so far) only targeting the backup data hosted on Filer-B
  - the backup-mirroring I'm considering is all within that one
server, not across a network connection
  - I can't have "each disk configured as a single VG", since the
whole point of my using LVM is to get as much flexibility as possible
for dozens of hosts to share my dozen-terabyte disk space, when I only
have a half-dozen disks.
  - my goal is for the snapshot-copy to end up in a regular partition
on a physical disk, without any RAID/LVM layers standing between the
data and easy recovery

However your main point is perfectly valid - dd basically does the
same block-level data transfer as mdm RAID1 - which is a must for the
gazillions-of-hardlinks backup filesystems (as opposed to file-level
tools like rsync).

So adapting your suggestion to fit (my perception of) my needs:

  - create an LV snapshot
  - mount a plain partition on a physical hard disk (preferably on a
separate controller?)
  - dd the data from the LV snapshot over to the partition
  - delete the snapshot

> A RAID mirror can only duplicate the raw block device.

Isn't that all that dd is doing as well?


My perception is that software like mdm, designed as it is to maximize
data reliability would handle the cloning more reliably than dd -
isn't there more error-checking going on during a RAID1 re-mirroring?
Your main (and quite valid) point is that a user-space tool designed
to do the job is probably more appropriate than putting RAID1 to use
in a way beyond what was originally intended.


So I guess my question becomes:

What is the best tool to block-level clone an LV snapshot to a regular
disk partition?

  - "best" = as close to 100% reliably as possible, speed isn't nearly
as important

Would a COT cloning package (something like Acronis TrueImage) have
data reliability advantages (like mdm's) over dd?
