From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID 1 | Restore based on Image of /dev/sda
Date: Mon, 4 May 2020 13:07:15 +0100
Message-ID: <5EB00573.9040503@youngman.org.uk>
References: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
 <5EAFF763.2000906@youngman.org.uk>
 <58659d1e-bcce-553c-fe68-52d075422252@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58659d1e-bcce-553c-fe68-52d075422252@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/20 12:26, Stefanie Leisestreichler wrote:
> 

> 
> Thanks, Wol, especially for the hint with the GUIDs, will keep this in
> mind. If ever using it again - maybe in case of a quick temporary
> replacement in the original computer - I will wipe it with zeros before.

And what Johannes said ... oh and I believe gdisk has an option that
will change guids for you without affecting anything else.

Wiping it with zeroes will take a long time - it might well be mdadm I
think it has an option to wipe the raid superblock.

Note that both the partitions and the raid will have guids, so moving
drives around can be fraught ...
> 
> The partition layout will be cloned using sfdisk.
> 
> Thanks for the wiki links. I read the wiki before asking but it was not
> clear to me how to do it...
> 
> Btw, I will stay with mdadm/lvm/ext4 and not switch to btrfs.
> 
That's good - my feelings entirely as btrfs may be a decent file system,
but I gather parity raid is experimental as in it will probably eat your
data at some point and may be unfixable. I gather it also does NOT
mirror your data by default (typical computer scientists - they consider
the filesystem structure valuable and assume the user can retrieve the
data from backup ... :-(

lvm gives you snapshotting and stuff ...

And my current (and planned new) systems both have the root filesystem
on a separate partition from /home, so if I wanted I could have root on
a 1.0 mirror - not especially recommended but there are good reasons for
it ...

> Thanks again,
> Steffi

Cheers,
Wol
