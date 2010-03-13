From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Sun, 14 Mar 2010 00:31:01 +0300
Message-ID: <70ed7c3e1003131331g14e30331k8b97520c906431fd@mail.gmail.com>
References: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
	<20100314082649.187dae9a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100314082649.187dae9a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

Since when was this possible? I always thought that it had to have an
even number of disks.

On Sun, Mar 14, 2010 at 12:26 AM, Neil Brown <neilb@suse.de> wrote:
> On Sat, 13 Mar 2010 16:06:38 -0500
> Carlos Mennens <carloswill@gmail.com> wrote:
>
>> I was told by my distributions Wiki page that Grub doesn't support
>> RAID 5 or RAID 6 so I would need to create a volume with three disks
>> and set the level to RAID 1:
>>
>> # mdadm --create /dev/md1 --level=3D1 --raid-devices=3D3 /dev/sda1
>> /dev/sdb1 /dev/sdc1 --spare-devices=3D1 /dev/sdd1
>>
>> Is this possible to mirror three identical drive partitions? I was
>> talking to some co-workers and was told that I could only pair two
>> drives on RAID 1.
>
> Your co-workers are wrong, at least for md raid. =C2=A0With md, a RAI=
D1 can have
> any number of devices from 1 upwards - the limit varies in different
> situations but is at least 28.
>
> Try it and see.
>
> NeilBrown
>
>>
>> Can anyone please help me understand this?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
