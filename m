From: LM <linux-raid@moellendorf.eu>
Subject: Re:  Level change from 4 disk RAID5 to 4 disk RAID6
Date: Tue, 11 Apr 2017 23:28:39 +0200
Message-ID: <20170411212839.GD25873@lars-laptop>
References: <20170408214239.GF10267@lars-laptop>
 <58EB1AF4.5010005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58EB1AF4.5010005@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 10, 2017 at 06:41:08AM +0100, Wols Lists wrote:
>On 08/04/17 22:42, LM wrote:
>> Hi,
>>
>> I have a 4 disk RAID5, the used dev size is 640.05 GB. Now I want to
>> replace the 4 disks by 4 disks with a size of 2TB each.
>>
>> As far as I understand the man page, this can be achieved by replacing
>> the devices one after another and for each device rebuild the degraded
>> array with:
>>
>>    mdadm /dev/md0 --add /dev/sdX1
>
>Do you have a spare SATA port or whatever your drives are. If so, then
>use the --replace option to mdadm, don't fail then add. You're risking a
>drive failure taking out your array - not a good move.
>
>And if you don't have a spare port, $20 for a PCI card or whatever is a
>good investment to keep your data safe.
>
>Have a look at the raid wiki - it tries to be a bit more verbose and
>easily comprehensible than the man page.
>
>Cheers,
>Wol

Thx for hinting me at --replace, I missed it. Yes, I have a spare SATA
port.

I successfully tested it using loop devices:

mdadm /dev/md/test --add-spare /dev/loop20 --replace /dev/loop10 --with /dev/loop20
mdadm /dev/md/test --add-spare /dev/loop21 --replace /dev/loop11 --with /dev/loop21
mdadm /dev/md/test --add-spare /dev/loop22 --replace /dev/loop12 --with /dev/loop22
mdadm /dev/md/test --add-spare /dev/loop23 --replace /dev/loop13 --with /dev/loop23
mdadm /dev/md/test --remove /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13
mdadm --grow /dev/md/test --size max
mdadm --grow /dev/md/test --level=6 --raid-disk=4 --backup-file=/root/backup-md-test --force
mdadm --grow /dev/md/test --array-size 407552
mdadm --grow /dev/md/test --raid-disk=4 --layout=normalise --backup-file=/root/backup-md-test

