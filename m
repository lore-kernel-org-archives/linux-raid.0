From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Mon, 4 Jun 2012 17:06:21 +0800
Message-ID: <CA+sTkh5_GHKv2G6-m6pU+XyvryEn9nK2=TvKJiftDd1VkSiy_Q@mail.gmail.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com>
 <20120601192524.GH3867@bitfolk.com> <4FC9A8D4.9060803@hardwarefreak.com>
 <20120603033042.GI3867@bitfolk.com> <CA+sTkh49kYa=sqzSNhnQtjMTs7OL=kmpsoP55k1zifFVByzENw@mail.gmail.com>
 <20120603220536.GN3867@bitfolk.com> <4FCC1578.50801@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCC1578.50801@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 June 2012 09:55, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 6/3/2012 5:05 PM, Andy Smith wrote:
[=E2=80=A6]
> >> =C2=A0 =C2=A0Kinda off-topic question =E2=80=94 why having separat=
e MDs for swap and
> >> root? I mean LVM's lv would be just fine for them.
> >
> > I know, but I'm kind of old-fashioned and have some (probably
> > unwarranted) distrust of having the really essential bits of the
> > system in LVM if they don't really need to be.
>
> I wouldn't say unwarranted. =C2=A0I've seen instances on this and oth=
er lists
> where an md array blew chunks, was repaired and everything reported
> good, only to have LVM devices corrupted beyond repair. =C2=A0Or both=
 md and

   Sounds like urban myths to me. LVM's dev-mapper here is nothing
more as merely block look-up/translation table.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
