From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 22 Dec 2016 09:35:53 +0100
Message-ID: <CAMGffEk-eTYxUj5a0YbfWzKM+mGx7pXF7ZS72GbREwPKFK4NTA@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
 <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com>
 <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com>
 <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
 <87oa07tu6q.fsf@notabene.neil.brown.name> <CAMGffEmEUg2Xrg-v_z+cMxzsH-Uk6bDCqTSA7vGoPw4f2dvu0A@mail.gmail.com>
 <871sx2thvt.fsf@notabene.neil.brown.name> <CAMGffE=OVX-jp+-SY8A4pmJHyVAkVQVXSCa_3VgndFf4tYyG9w@mail.gmail.com>
 <878tr8rgc3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tr8rgc3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Thu, Dec 22, 2016 at 12:51 AM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Dec 21 2016, Jinpu Wang wrote:
>
>>>
>> Thanks, it does help a lot, I attached the patch I'm still testing,
>> but so far so good.
>> Could you check if I got it right?
>
> Yes, that looks exactly right.
> I guess one of us should try to push it upstream... maybe next year :-)
>
> Thanks,
> NeilBrown

Thanks, Neil. I will try to push to upstream next year!
Happy holidays!

Cheers!
--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
