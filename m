From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: Re: argh!
Date: Sun, 31 Oct 2010 21:18:52 +0000
Message-ID: <AANLkTimL=Z5gh+cbadd5+k66AoNZ8xc9upMbfE_Yqxac@mail.gmail.com>
References: <AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>
	<C4.61.07087.9F0BCCC4@cdptpa-omtalb.mail.rr.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C4.61.07087.9F0BCCC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 October 2010 00:57, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>> >> > a new HDD has failed on me during a scrub.... i tried to remove=
/fail
>> it
>> >> but
>> >> > it kept saying the device was busy. so i forced a reboot.
>
> =A0 =A0 =A0 =A0BTW, it's better, if you can, to free up the device, r=
ather than
> reboot. =A0Now that you have rebooted, that's no longer possible.
>
>> >> > I have physically disconnected the drive..
>> >> >
>> >> > can anyone take alook at the examine below and tell me if it is
>> should
>> >> > assemble ok?
>> >> >
>> >> > I tried
>> >> >
>> >> > mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sd=
e1
>> >> /dev/sdf1
>> >> > /dev/sdg1
>> >>
>> >> I'd try:
>> >>
>> >> mdadm --assemble /dev/md4 /dev/sd{g,a,e}1 missing /dev/sd{d,b,f}1
>> >
>> >
>> > =A0 =A0 =A0 =A0Yeah, I would, too. =A0Also, what are the contents =
of
>> > /etc/mdadm/mdadm.conf? =A0If it is correct, then `mdadm --assemble=
 --scan`
>> > should work.
>> >
>> >
>>
>> Hey, yeah I am confused as drives have failed before and it has stil=
l
>> assembled. I think it is because it is unclean....
>>
>> Can I ask how did you arrive at the command list?
>
> =A0 =A0 =A0 =A0Look at the results of --examine. =A0Every one shows t=
he list of
> drives and their order.
>
>> what is wrong with dbf?
>
> =A0 =A0 =A0 =A0'No idea. =A0SMART might give you an idea, or the kern=
el logs.
>
>> also this is my mdadm.conf
>>
>>
>> DEVICE /dev/sd[abcdefg]1 /dev/hd[ab]1
>>
>> ARRAY /dev/md/4 metadata=3D0.90 UUID=3D7438efd1:9e6ca2b5:d6b88274:70=
03b1d3
>> ARRAY /dev/md/3 metadata=3D0.90 UUID=3Da1f24bc9:4e72a820:3a03f7dc:07=
f9ab98
>> ARRAY /dev/md/2 metadata=3D0.90 UUID=3D0642323a:938992ef:b750ab21:e5=
a55662
>> ARRAY /dev/md/1 metadata=3D0.90 UUID=3Dd4eeec62:148b3425:3f5e931c:bb=
3ef499
>
> =A0 =A0 =A0 =A0--scan may work. =A0I suggest updating the file with a=
ll the array
> members. =A0Why are all the arrays assembled with 0.90 superblocks? =A0=
The 0.90
> superblock has some significant limitations. =A0They may not be causi=
ng you
> grief right now, but they could in the future. =A0The only arrays I h=
ave built
> with 0.90 superblocks are the /boot targets, because GRUB2 does not s=
upport
> 1.x superblocks. =A0I've chosen 1.2 for all the others.
>

Hi,

Thanks for your help. I use 0.90 as that is what there was when the
machine was build ~3yrs ago.. the array has been grown and resized
since then.

Does anyone have a feature list for the superblocks? Why upgrade.....?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
