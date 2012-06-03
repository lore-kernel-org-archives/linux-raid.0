From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sun, 3 Jun 2012 12:05:31 +0800
Message-ID: <CA+sTkh49kYa=sqzSNhnQtjMTs7OL=kmpsoP55k1zifFVByzENw@mail.gmail.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com>
 <20120601192524.GH3867@bitfolk.com> <4FC9A8D4.9060803@hardwarefreak.com> <20120603033042.GI3867@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120603033042.GI3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 June 2012 11:30, Andy Smith <andy@strugglers.net> wrote:
> I probably didn't give enough details. On this particular host there
> are four md arrays:
>
> md0 is mounted as /boot
> md1 is used as swap
> md2 is mounted as /
> md3 is an LVM PV for "everything else"
[=E2=80=A6]

   Kinda off-topic question =E2=80=94 why having separate MDs for swap =
and
root? I mean LVM's lv would be just fine for them.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
