From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 09:15:40 -0400
Message-ID: <4E7F297C.9070403@turmel.org>
References: <4E7EDE58.3000804@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7EDE58.3000804@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/25/2011 03:55 AM, Marcin M. Jessa wrote:
> Hi guys.
> 
> 
> I have a RAID 6 setup with 5 2TB drives on Debian Wheezy [1] & [2].
> Yesterday 3 of the drives failed working leaving the RAID setup broken.
> Following [5] I managed to start the array and make it resync.
> The problem I'm facing now is I cannot access any of the LVM partitions [3] I have on top of my md0. Fdisk says the disk doesn't contain a valid partition table [4].
> I tried to run fsck on the lvm devices without luck.
> Has any of you a suggestion, a method I could use to access my data please?

[trim /]

> [5]: http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock

These instructions are horrible!  If you make the slightest mistake, your data is completely hosed.

If first asks for your "mdadm -E" reports from the drives, but it has you filter them through a grep that throws away important information.  (Did you keep that report?)

Next, it has you wipe the superblocks on the array members, destroying all possibility of future forensics.

Then, it has you re-create the array, but omits "--assume-clean", so the array rebuilds.  With the slightest mistake in superblock type, chunk size, layout, alignment, data offset, or device order, the rebuild will trash your data.  Default values for some of those have changed in mdadm from version to version, so a naive "--create" command has a good chance of getting something wrong.

There is no mention of attempting "--assemble --force" with your original superblocks, which is the correct first step in this situation.  And it nearly always works.

I'm sorry, Marcin, but you shouldn't expect to get your data back.  Per your "mdadm -D" report, the rebuild was already 63% done, so the destruction of your data is certainly complete now.

Regards,

Phil
