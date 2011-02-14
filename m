From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10 failure(s)
Date: Tue, 15 Feb 2011 09:48:02 +1100
Message-ID: <20110215094802.44d99c58@notabene.brown>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
	<AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <grimm26@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 14:33:03 -0600 Mark Keisler <grimm26@gmail.com> wrote:

> Sorry for the double-post on the original.
> I realize that I also left out the fact that I rebooted since drive 0
> also reported a fault and mdadm won't start the array at all.  I'm not
> sure how to tell which members were the in two RAID0 groups.  I would
> think that if I have a RAID0 pair left from the RAID10, I should be
> able to recover somehow.  Not sure if that was drive 0 and 2, 1 and 3
> or 0 and 1, 2 and 3.
> 
> Anyway, the drives do still show the correct array UUID when queried
> with mdadm -E, but they disagree about the state of the array:
> # mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 | grep 'Array State'
>    Array State : AAAA ('A' == active, '.' == missing)
>    Array State : .AAA ('A' == active, '.' == missing)
>    Array State : ..AA ('A' == active, '.' == missing)
>    Array State : ..AA ('A' == active, '.' == missing)
> 
> sdc still shows a recovery offset, too:
> 
> /dev/sdb1:
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> /dev/sdc1:
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 2 sectors
> /dev/sdd1:
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> /dev/sde1:
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> 
> I did some searching on the "READ FPDMA QUEUED" error message that my
> drive was reporting and have found that there seems to be a
> correlation between that and having AHCI (NCQ in particular) enabled.
> I've now set my BIOS back to Native IDE (which was the default anyway)
> instead of AHCI for the SATA setting.  I'm hoping that was the issue.
> 
> Still wondering if there is some magic to be done to get at my data again :)

No need for magic here .. but you better stand back, as
  I'm going to try ... Science.
(or is that Engineering...)

 mdadm -S /dev/md0
 mdadm -C /dev/md0 -l10 -n4 -c256 missing /dev/sdc1 /dev/sdd1 /dev/sde1
 mdadm --wait /dev/md0
 mdadm /dev/md0 --add /dev/sdb1

(but be really sure that the devices really are working before you try this).

BTW, for a near=2, Raid-disks=4 arrangement, the first and second devices
contain the same data, and the third and fourth devices also container the
same data as each other (but obviously different to the first and second).

NeilBrown

