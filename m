From: Michael McCallister <mike@mccllstr.com>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 06:07:31 +0000 (UTC)
Message-ID: <loom.20100412T075555-215@post.gmane.org>
References: <loom.20100411T185315-118@post.gmane.org> <4BC29670.6020504@unart.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom=C3=A1=C5=A1 Dul=C3=ADk <dulik <at> unart.cz> writes:
> I am not sure if I understand your question, but I suppose you will h=
it=20
> the problem of udev naming of your disks, and if your disks are=20
> hotswap-able, then also the problem of hotswap, which is currently=20
> discussed here in this mailing list.

Thanks for the heads up.  I did the swap while powered down and only br=
ought the
system up using an Ubuntu Live CD, so the udev on my current root parti=
tion
didn't come into play.  During that live-CD boot, I had no apparent pro=
blems
with the changing device names.  They had changed pretty significantly:=
 sdb
became sdd, sdc became sdb, sdd became sde, and another device not part=
 of the
array became sdc.  In spite of the shuffle and a new SATA controller, m=
dadm was
able to reassemble the RAID devices on those drive partitions with no i=
nput from
me.  I believe this is because mdadm scanned the partitions looking dev=
ice for
the appropriate UUIDs in the metadata, and with all the devices account=
ed for,
it was able to "do the right thing".  I was very impressed.

When I boot using the original root partition (running Ubuntu Hardy), m=
aybe udev
will shuffle the device names more severely.  But so long as mdadm is c=
onfigured
to scan all the available partitions, I expect it will locate all the p=
ieces,
whatever they may be named, and successfully reassemble the arrays.


Mike


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
