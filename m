From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Mdadm, udev and fakeraid?
Date: Fri, 22 Apr 2011 19:37:40 -0700
Message-ID: <BANLkTik6qpCx-Y=DXY6U6yu0habSohyiPw@mail.gmail.com>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
	<20110405162008.5f2c48fe@notabene.brown>
	<BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
	<20110418103852.2ead1a69@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110418103852.2ead1a69@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Seblu <seblu@seblu.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 17, 2011 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 15 Apr 2011 16:15:50 +0200 Seblu <seblu@seblu.net> wrote:
>
>> On Tue, Apr 5, 2011 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 3 Apr 2011 18:03:50 +0200 Seblu <seblu@seblu.net> wrote:
>> >
>> >> Hello,
>> >>
>> >> In the following commit, udev rules load isw_raid (fakeraid). Fro=
m my
>> >> test, this doesnt work. I have to call dmraid to have something
>> >> working.
>> >> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommit;h=3D475a01b8bce85=
75dd1b2ab6495e65e854702ac0e
>> >>
>> >> isw_raid is only fakeraid devices? mdadm is able to mount fakerai=
d partition?
>> >>
>> >
>> > I'm sorry but I cannot parse those questions successfully so I'm n=
ot sure
>> > what you are asking.
>>
>> Hello Neil,
>>
>> in my previous mail, i used word fakeraid about raid created with
>> dmraid and i used softraid about raid created with mdadm. it was not
>> clear.
>>
>> So my question was about compatibily. Raids created by dmraid can be
>> assembled with mdadm and vice versa?
>>
>> > Both dmraid and mdadm can manage some 'fakeraid' arrays. =A0dmraid=
 supports a
>> > wider variety. =A0mdadm supports raid1 and raid5 more completely t=
han dmraid
>> > does.
>> mdadm -> create soft raid for linux =A0(now there is new format: ddf=
 and imsm) ?
>> dmraid -> create soft raid from industry raid card format =A0?
>
> No, it isn't that simple.
>
> dmraid uses the 'dm' kernel module. =A0mdadm uses the 'md' kernel mod=
ule.
>
> As such dmraid doesn't support RAID5 (yet) and doesn't support RAID1 =
very
> well.
> mdadm supports both of these well, but doesn't support the same range=
 of
> "industry raid card formats".
>
> There is a growing amount of overlap.
>
>>
>> > Both should support isw to some degree.
>> > Intel are currently working with mdadm to make it provide full sup=
port for
>> > "IMSM" (Intel Matrix Storage Manager). =A0I don't know the exact r=
elationship
>> > between 'isw' and 'IMSM' - maybe they are different names for the =
same thing.
>> ok
>>
>> > If mdadm doesn't work for your isw arrays, and you want it to, the=
n I suggest
>> > you report details about what is, or is not, happening.
>> My purpose is to improve archlinux startup detection of fakeraids
>> (mdadm + dmraid).
>>
>> With mdadm everything works correctly without call to "mdadm -As"
>> With dmraid, no raid is created by udev rules, so we need to run
>> "dmraid -i -ay" at startup.
>>
>> To test this kind of raid, i created a dmraid array in a vm. This
>> created me a /dev/mapper/isw_bfbjdbadhb_testF device.
>> call blkid on a disk member of this raid tell me this:
>> /dev/sde: TYPE=3D"isw_raid_member"
>> and on "mdadm" created raid:
>> /dev/sdd: UUID=3D"a974b525-993a-1481-f860-6471f3f120e1"
>> UUID_SUB=3D"eb22aee2-b2ee-e56d-1008-44d52c63564d" LABEL=3D"archipel:=
0"
>> TYPE=3D"linux_raid_member"
>>
>> This misled me because mdadm udev rules uses the output of blkid to
>> mount raids which have type "isw_raid_member".
>> What disturbs me is that mdadm cannot mount raid created by dmraid
>> with type isw_raid_member.
>>
>> About outputs:
>> mdadm -I --verbose /dev/sde
>> mdadm: no RAID superblock on /dev/sde.

Seblu can you verify that:
    export IMSM_NO_PLATFORM=3D1
    mdadm -E /dev/sde

finds no superblock? It may be that dmraid has laid down something inco=
mpatible.

> As has been mentioned elsewhere, mdadm only recognised IMSM arrays on
> machines with IMSM hardware. =A0I'm not entirely happy about this and=
 may well
> change it.

I have trouble answering the "least surprise" question in this area.

Is it more surprising to go into your BIOS, explicitly turn off raid
support and still see raid devices showing up?

Or is it more surprising to take a raid array from a raid enabled
system to raid disabled system and wonder why things won't assemble?

=46or safety I think it is better if mdadm not perform operations that
might be incompatible with the platform option-rom.  But if you need
to recover to a usb attached drive, or some other
platform-incompatible configuration, you can use the environment
variable in a pinch.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
