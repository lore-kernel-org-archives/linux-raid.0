From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: raid array not auto restarting
Date: Sun, 23 Aug 2009 21:49:51 +0530
Message-ID: <5c45fce80908230919l4758035bq558f7a2b23c28588@mail.gmail.com>
References: <5c45fce80908230649y4acc48acxefc8a4bef698e860@mail.gmail.com>
	 <20090823135530.GA9860@cthulhu.home.robinhill.me.uk>
	 <5c45fce80908230832h3728daf5x7c2636c3cb892deb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c45fce80908230832h3728daf5x7c2636c3cb892deb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I forgot to mention that it didn't work ...I am including my
mdadm.conf also for reference. All my partitions and devices are
visible in /proc/partitions.

One change after the initramfs....now I don't have any arrays show up
in proc/mdstat but the assemble, scan gets them all perfectly...its
just not happening automatically at boot time like it used to.

cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST GATEWAY

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md_d127 LEVEL=3Draid5 NUM-DEVICES=3D4 METADATA=3D1.2
UUID=3D42c56ea0:2484f566:387adc6c:b3f6a014
DEVICES=3D/dev/sdb,/dev/sdd5,/dev/sdc5,/dev/sda1 NAME=3DGATEWAY:raid5_2=
80G
ARRAY /dev/md_d126 LEVEL=3Draid5 num-devices=3D3 METADATA=3D1.2
UUID=3D54b83ff7:55316d90:d497a0cb:5a3309fe
DEVICES=3D/dev/sdc6,/dev/sdd6,/dev/sda2 NAME=3DGATEWAY:raid5_186G
ARRAY /dev/md_d125 LEVEL=3Draid5 NUM-DEVICES=3D2 METADATA=3D1.2
UUID=3De501ec78:3e45999f:4ecca49e:d48db221 DEVICES=3D/dev/sdc7,/dev/sdd=
7
NAME=3DGATEWAY:raid5_178G

2009/8/23 Anshuman Aggarwal <anshuman.aggarwal@gmail.com>:
> I ran update-initramfs -u to update (which should work for ubuntu
> jaunty)...should it be needed, since my root partition is not on raid=
?
> I didn't need to do it so far with any other cluster change?
>
> 2009/8/23 Robin Hill <robin@robinhill.me.uk>:
>> On Sun Aug 23, 2009 at 07:19:44PM +0530, Anshuman Aggarwal wrote:
>>
>>> Although its not a show stopper, would really appreciate some help =
on this.
>>>
>>> My raid arrays don't start up automatically like they used to after=
 I
>>> grew them to include the 4th disk (yes, I DID modify the mdadm.conf=
 so
>>> I'm not sure what's not working here)
>>> Kernel: 2.6.30.4; mdadm 3.0 (are there any other libraries whose
>>> version I should be checking also, since I manually upgraded Ubuntu
>>> Jaunty to mdadm 3.0)
>>>
>> <-snip->
>>>
>>> This array starts fine when I do the following:
>>>
>>> mdadm -S /dev/md_d1*
>>> mdadm -A -s
>>>
>>> So, if the scan works without any changes in the mdadm, then why
>>> doesn't it work at boot time?
>>>
>> Have you updated the initrd so the new mdadm.conf is available at bo=
ot?
>>
>> Cheers,
>> =A0 =A0Robin
>> --
>> =A0 =A0 ___
>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@=
robinhill.me.uk> |
>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
