From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: RAID 1 | Restore based on Image of /dev/sda
Date: Mon, 4 May 2020 13:26:35 +0200
Message-ID: <58659d1e-bcce-553c-fe68-52d075422252@peter-speer.de>
References: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
 <5EAFF763.2000906@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5EAFF763.2000906@youngman.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04.05.20 13:07, Wols Lists wrote:
> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Is the drive formatted with one big partition? I guess it is. What it
> really cares about is that the new partition you are adding is identical
> in size to the partition the raid is on.
> 
> There are tools that will copy a partition table for you - BEWARE - a
> lot of things rely on GUIDs and at least the tools I know of don't reset
> them by default - duplicate unique ids are not a good idea :-) So as you
> copied this drive using dd DO NOT put it back in the original computer ...
> 
> https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Adding_a_drive_to_a_mirror
> 
> Cheers,
> Wol

Thanks, Wol, especially for the hint with the GUIDs, will keep this in 
mind. If ever using it again - maybe in case of a quick temporary 
replacement in the original computer - I will wipe it with zeros before.

The partition layout will be cloned using sfdisk.

Thanks for the wiki links. I read the wiki before asking but it was not 
clear to me how to do it...

Btw, I will stay with mdadm/lvm/ext4 and not switch to btrfs.

Thanks again,
Steffi
