From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Tue, 22 Sep 2009 14:42:41 -0400
Message-ID: <200909221442804.SM02380@trainer>
References: <70ed7c3e0909220823v40badc3fu4c11e8712028535b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909220823v40badc3fu4c11e8712028535b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nothing showed up when I did  "sudo lvscan". I'm pretty much stumped.

-----Original Message-----
=46rom: Majed B. [mailto:majedb@gmail.com]=20
Sent: Tuesday, September 22, 2009 11:24 AM
To: Sunpyo Hong
Cc: Robin Hill; linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

When the array is properly assembled, "sudo lvscan" should show any
logical volumes. Maybe even without the array assembled.

If nothing shows up, then you don't have an LV configured.

On Tue, Sep 22, 2009 at 6:15 PM, Sunpyo Hong <sunpyo.hong@amac.com> wro=
te:
>> I am stopping and starting the array. I couldn't mount in both insta=
nces.
>> The before is the initial assembly array that I force assembled thro=
ugh
>> mdadm -Af. This assembled the raid, but couldn't see an ext3 file sy=
stem.
>
>>I haven't followed all of this thread, so maybe I missed something,
>>but have you considered the possibility that there is an LVM config
>>on the md array, and that the ext3 filesystem is inside a logical
>>volume?
>
>>NeilBrown
>
> Hi Neil, I already checked with western digital and its support team.=
 What
> they've told me is that the Raid is an EXT3 and is not LVM config on =
the
HD,
> however knowing WD they might just say that so I'd fork over the cash=
 to
get
> my HD recovered for thousands of dollars from them. Is there a way I =
can
> check if it's LVM config-ed? Thanks!
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
       Majed B.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
