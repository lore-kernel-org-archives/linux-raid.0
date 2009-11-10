From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Tue, 10 Nov 2009 08:22:50 -0600
Message-ID: <cccedfc60911100622l3bf9c01do5aaf92a64ad4ecd9@mail.gmail.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>
	<4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
	<alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se> <4AF8847D.8030303@redhat.com>
	<alpine.DEB.1.10.0911100920510.22728@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0911100920510.22728@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 2:25 AM, Mikael Abrahamsson <swmike@swm.pp.se> =
wrote:
> On Mon, 9 Nov 2009, Doug Ledford wrote:
>
>> Of course, I recently had a bug report that I ended closing out as N=
OTABUG
>> because of this very ability. =A0The person had arrays with 1.2 supe=
rblocks,
>> and they went to add a new disk, and all the existing disks had a sp=
ecific
>> partition layout, so he copied that to the new disk, then tried to a=
dd the
>> partition to the raid array. =A0It kept returning "device too small =
for
>> array". =A0Then, upon inspection, we come to see he has a 1.2 superb=
lock on
>> the *entire* drive, which left the partition table intact, but the p=
artition
>> table is *pointless* because the array is on the whole disk devices.=
 =A0This
>> sort of confusion is bad. =A0So, while I could see making it 1.2 for
>> partitions (so that boot sectors won't overwrite the superblock), I =
wouldn't
>> make it 1.2 for whole disk devices, and in fact it might be wise to =
refuse
>> to create 1.2 superblocks on whole disk devices. =A0Just a thought.
>
> Well, same thing there, if you create a partition table you don't bre=
ak the
> superblock. Perhaps something needs to be able to discern between the
> superblock being "whole disk" and on a partition? Personally I put 1.=
2 on
> "whole disk" (no partition table at all), and I would really HATE thi=
s
> possibility going away. I like it the way it is and feel comfortable =
with it
> and I don't want 1.0 or 1.1 superblocks in my setup.

Since I almost always use partitions (this way, the partition *type*
is "Linux RAID") I largely avoid this issue.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
