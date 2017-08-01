From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Tue, 1 Aug 2017 10:01:24 -0400
Message-ID: <206a4a06-c586-3204-d1b9-0dcc840fefa7@turmel.org>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
 <20170605235619.GA8478@metamorpher.de>
 <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
 <20170610204105.GA19409@metamorpher.de>
 <e0c059b0-2d68-92bf-3eb9-e2827602061c@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e0c059b0-2d68-92bf-3eb9-e2827602061c@tonel.li>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/31/2017 03:57 PM, Paul Tonelli wrote:
> Hello (again)
> 
> Sorry to resuscitate this topic back from the dead, but I have again the
> same issue.
> 
> TL;DR
> 
> The difference compared to last time:
> - I created a clean raid a few days back
> - the data is completely backed up and available
> - I can actually access the data
> 
> but I still have no clue about what went wrong.
> 
> 1) I created the raid:
> 
> sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3
> /dev/sdb /dev/sdc /dev/sdd
> 
> without lvm this time, juste a single ext4 partition
> 
> mkfs.ext4 /dev/md0
> mount /dev/md0 /srv/data
> 
> I copied 3Tb on it
> 
> I just rebooted the machine
> 
> 2) and (again) no md0 assembled at boot:
> 
> mdadm -E /dev/sd[bcd]
> /dev/sdb:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> /dev/sdd:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)

You have partition tables on these drives, but you are using the entire
drives when you create your arrays.  You need to zero the first 4k of
each drive to kill off the incorrect partition tables.

You might also have a GPT partition table backup at the end of the disk
that needs to die as well.

Phil
