From: Phil Turmel <philip@turmel.org>
Subject: Re: 'resync=PENDING', 'auto-read-only' on raid1 creation
Date: Sat, 04 Jan 2014 11:38:27 -0500
Message-ID: <52C83903.8020204@turmel.org>
References: <52C80C81.3040004@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C80C81.3040004@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ron,

On 01/04/2014 08:28 AM, Ron Leach wrote:
> List, good afternoon,
> 
> I've recently needed to create a new raid1 array in an existing
> (non-raid) Debian Wheezy system.  The array has been created read-only,
> and resync is PENDING; I didn't expect either of these conditions.
> 
> Objective is to have an LVM built initially on mirrored unused 2TB
> drives, with a view to growing the LVM with mirrored 3TB drives in the
> future.  The Logical volume will be exported over NFS, and will serve as
> a repository for backups of other machines.  The approach I am following
> is, first, to create a raid1 array then, second, install an LVM over
> that array, making sure that I create the LVM such that it can be expanded.
> 
> (I think) I've created a raid1 on two empty and unpartitioned 2TB
> drives, but am not seeing the results that the wiki
> (https://raid.wiki.kernel.org/index.php/RAID_setup) seems to suggest.
> 
> # cat /proc/mdstat
> reports
> 
> md0 : active (auto-read-only) raid1 sdc[1] sdb [0]'
> 1953383360 blocks super 1.2 [2/2] [UU]
> resync=PENDING
> 
> This was the create command I used:
> 
> # mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
> 
> I've read through man mdadm but had not expected 'auto-read-only', nor
> 'resync=PENDING'.  Has something gone wrong, for some reason?  Or do I
> need, simply, to set the array to be read-write?  I wondered whether
> 'create' does not 'start' the array, but it's reported as 'active', so I
> think the array is started.  I have not yet put a filesystem on the
> array, because I am not sure the creation is ok.
> 
> Grateful for any comment, and apologies for what must seem a very basic
> question,

"auto-read-only" is a safety measure that prevents any writes to an
array until something in the data area is written.  I don't remember the
rules MD uses to determine if any given assemble/create operation
qualifies, but it isn't an error.

Just perform pvcreate on the array as you intended, and that'll switch
the array to rw (and start the resync).

HTH,

Phil
