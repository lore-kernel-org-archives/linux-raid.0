From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Sat, 3 Sep 2011 10:03:33 -0700
Message-ID: <CAEUYfyNPAeeZ=hjaefNYv=uQmgLViCyxqaNnLujp6Ru4+8q32g@mail.gmail.com>
References: <4E57FE4D.5080503@vorgon.com>
	<20110827084535.5e64bf5c@notabene.brown>
	<4E5FC63A.1040206@vorgon.com>
	<CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com>
	<4E60F95C.40203@vorgon.com>
	<CAEUYfyPWFwyadvYC8pUTssQMpGhqEoB0aTHtM_3yb7o33M1Edw@mail.gmail.com>
	<20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>, "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 3, 2011 at 5:17 AM, Robin Hill <robin@robinhill.me.uk> wrot=
e:
> On Sat Sep 03, 2011 at 04:35:39 -0700, Simon Matthews wrote:
>
>> On Fri, Sep 2, 2011 at 8:42 AM, Timothy D. Lenz <tlenz@vorgon.com> w=
rote:
>> >
>> >>
>> >> How did you install Grub on the second drive? I have seen some
>> >> instructions on the web that would not allow the system to boot i=
f the
>> >> first drive failed or was removed.
>> >>
>> >
>> >
>> > I think this is how I did it, at least it is what I had in my note=
s:
>> >
>> > grub-install /dev/sda && grub-install /dev/sdb
>> >
>> > And this is from my notes also. It was from an IRC chat. Don't kno=
w if it
>> > was the raid channel or the grub channel:
>> >
>> > [14:02] <Jordan_U> Vorg: No. First, what is the output of grub-ins=
tall
>> > --version?
>> > [14:02] <Vorg> =A0(GNU GRUB 1.98~20100115-1)
>> > [14:04] <Jordan_U> Vorg: Ok, then run "grub-install /dev/sda && gr=
ub-install
>> > /dev/sdb" (where sda and sdb are the members of the array)
>> >
>>
>> Which is exactly my point. You installed grub on /dev/sdb such that =
it
>> would =A0boot off /dev/sdb. But if /dev/sda has failed, on reboot, t=
he
>> hard drive that was /dev/sdb is now /dev/sda, but Grub is still
>> looking for its files on the non-existent /dev/sdb.
>>
> The way I do it is to run grub, then for each drive do:
> =A0 =A0device (hd0) /dev/sdX
> =A0 =A0root (hd0,0)
> =A0 =A0setup (hd0)
>
> That should set up each drive to boot up as the first drive.
>

How about (after installing grub on /dev/sda):
dd if=3D/dev/sda of=3D/dev/sdb bs=3D466 count=3D1

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
