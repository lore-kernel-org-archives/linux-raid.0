From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Failed Raid 5 due to OS mbr written on one of the array drives
Date: Wed, 4 Nov 2015 02:45:53 +1100
Message-ID: <5638D6B1.4010509@websitemanagers.com.au>
References: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
 <5637A92B.5010305@turmel.org>
 <CAArDwD9SDbH-Xdi6hRciLcYkWzY+Kv3JtgtWCyvELffJ=gv+0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAArDwD9SDbH-Xdi6hRciLcYkWzY+Kv3JtgtWCyvELffJ=gv+0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Tellier <telliern@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/11/15 01:21, Nicolas Tellier wrote:
> Hi Phil, and thanks for taking the time to reply to me.
>
> I'm not sure I understood you advice correctly.
> When you say leave off /dev/sdd, do you mean I should recreate a 3
> disks array like this :
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=3
> /dev/sda1 /dev/sdb1 /dev/sdc1
No, but lucky you checked
> Or a 4 disks array with no mention of /dev/sdd, like this (my instinct
> tell me that wouldn't work) :
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
> /dev/sda1 /dev/sdb1 /dev/sdc1
No, but lucky you checked
> Or, as I was thinking originally, to put /dev/sdd as missing, like so :
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
> /dev/sda1 /dev/sdb1 /dev/sdc1 missing /dev/sdd
No, but lucky you checked

What he means (I'm pretty sure) is that you should run the command:

mdadm --create --verbose --assume-clean /dev/md0 --level=5
--metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
/dev/sda1 /dev/sdb1 /dev/sdc1 missing /dev/sdd

but delete "/dev/sdd" from that, because you are using the wrong syntax.
Specifically, run this command:

mdadm --create --verbose --assume-clean /dev/md0 --level=5
--metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
/dev/sda1 /dev/sdb1 /dev/sdc1 missing

The word missing replaces a device name, because the device doesn't
exist. It doesn't say that the next device name is missing.


> I'm tempted to subscribe to the mailing list, but I'm afraid of the
> volume of e-mail I'm going to get. I originally tried to search
> through the archives, but couldn't find anything relevant to my case.
> I'm looking right now at the "timeout mismatch" results.
The list isn't that busy, I would guess around 10 per day. You can
always unsubscribe after you solve your problem, but staying subscribed
will let you learn a lot about common issues, especially the drive
timeout mismatch issues.

Regards,
Adam

[SNIP]

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

