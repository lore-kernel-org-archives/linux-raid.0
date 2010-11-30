From: Phil Turmel <philip@turmel.org>
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best
 of both worlds?
Date: Tue, 30 Nov 2010 11:56:05 -0500
Message-ID: <4CF52CA5.1090405@turmel.org>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>	<4CF3F7A0.2080108@rjl.com>	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>	<4CF4A472.20107@rjl.com>	<AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>	<4CF4F85C.1020806@turmel.org> <AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Nataraj <incoming-centos@rjl.com>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On 11/30/2010 10:39 AM, hansbkk@gmail.com wrote:
> On Tue, Nov 30, 2010 at 8:13 PM, Phil Turmel <philip@turmel.org> wrote:
>> I think you are making this overly complex, insisting on a RAID1 operation to backup from on filer to the other.  Consider having each disk on filer #2 configured as a single LVM PV/VG, so it can stand alone in a rotation.  The try the alternate below.
> 
> <snip>
> 
>> As an alternate, with simpler recovery semantics:
>>  Create matching LV on non-RAID PV/VG on filer #2
>>  dd + netcat + dd or other technique to dup the snapshot on filer #1 to filer #2
>>
>>>   - delete the snapshot
> 
> Thanks Phil, and yes I do tend to complicate things during a
> learning/planning stage, then when I get to implementation reality
> tends to force simplification :)
> 
> Perhaps I miscommunicated, but your suggestion misses a couple of factors:
>   - this process is (so far) only targeting the backup data hosted on Filer-B
>   - the backup-mirroring I'm considering is all within that one
> server, not across a network connection

OK.

>   - I can't have "each disk configured as a single VG", since the
> whole point of my using LVM is to get as much flexibility as possible
> for dozens of hosts to share my dozen-terabyte disk space, when I only
> have a half-dozen disks.

I meant only the disks that will be rotated offline/offsite should be
set up as "solo" Volume Groups.

>   - my goal is for the snapshot-copy to end up in a regular partition
> on a physical disk, without any RAID/LVM layers standing between the
> data and easy recovery

This wasn't clear, and is a key factor.  You can wipe the superblock from an mdraid mirror member, and if the SB was at the end of the partition, be left with usable partition (with a little waste space at the end).  But this doesn't help you, because the partition you want to clone is an LV inside LVM.  lvconvert can add a mirror to a partition on the fly, and split it off at an appropriate time, but only if the mirror is also inside LVM.  lvconvert can do some neat stuff, but its all inside LVM.

> However your main point is perfectly valid - dd basically does the
> same block-level data transfer as mdm RAID1 - which is a must for the
> gazillions-of-hardlinks backup filesystems (as opposed to file-level
> tools like rsync).

(Actually, rsync and tar are both hardlink-aware, at least the versions I use.)

> So adapting your suggestion to fit (my perception of) my needs:
> 
>   - create an LV snapshot
>   - mount a plain partition on a physical hard disk (preferably on a
> separate controller?)
>   - dd the data from the LV snapshot over to the partition
>   - delete the snapshot

Yep, this is basically what I recommended.

>> A RAID mirror can only duplicate the raw block device.
> 
> Isn't that all that dd is doing as well?

The raid operation carries a lot of metadata to track what is in sync vs. what's not, because it is expected to work on live filesystems.  If you are duping a snapshot, the snapshot is static, and dd will give you the same result, without the metadata overhead.

> My perception is that software like mdm, designed as it is to maximize
> data reliability would handle the cloning more reliably than dd -
> isn't there more error-checking going on during a RAID1 re-mirroring?
> Your main (and quite valid) point is that a user-space tool designed
> to do the job is probably more appropriate than putting RAID1 to use
> in a way beyond what was originally intended.

Well, both mdraid and dd will choke on a write error on the target.

> So I guess my question becomes:
> 
> What is the best tool to block-level clone an LV snapshot to a regular
> disk partition?
> 
>   - "best" = as close to 100% reliably as possible, speed isn't nearly
> as important

I would use dd.

> Would a COT cloning package (something like Acronis TrueImage) have
> data reliability advantages (like mdm's) over dd?

Not really.  But they may offer various forms of compression/sparsification/error detection if you wish to store the final backups as files.  Of course, if you do that, you might as well use tar+gzip+md5sum.

I'm guessing that you'll be scripting all of this, in which case I'd recommend sticking to some combination of lvcreate -s, lvconvert, dd, and possibly tar+gzip.

You want your dismountable disks to be accessible stand-alone, but I don't see why that would preclude setting them up so each is a unique LVM VG.

HTH,

Phil
