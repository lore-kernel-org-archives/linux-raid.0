From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Tue, 22 Sep 2009 18:23:54 +0300
Message-ID: <70ed7c3e0909220823v40badc3fu4c11e8712028535b@mail.gmail.com>
References: <20090921155621.GA29813@cthulhu.home.robinhill.me.uk>
	<200909221115737.SM02380@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909221115737.SM02380@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: Sunpyo Hong <sunpyo.hong@amac.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
the HD,
> however knowing WD they might just say that so I'd fork over the cash=
 to get
> my HD recovered for thousands of dollars from them. Is there a way I =
can
> check if it's LVM config-ed? Thanks!
>
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
