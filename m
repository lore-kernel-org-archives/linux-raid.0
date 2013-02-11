From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/2] Modernize udev rules
Date: Mon, 11 Feb 2013 14:16:17 +0400
Message-ID: <5118C4F1.90203@msgid.tls.msk.ru>
References: <1360432119-15910-1-git-send-email-thomas@archlinux.org> <20130211112016.3059ef95@notabene.brown> <5118ACE1.5020503@msgid.tls.msk.ru> <5118C3C0.2030708@archlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5118C3C0.2030708@archlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

11.02.2013 14:11, Thomas B=E4chler wrote:
> Am 11.02.2013 09:33, schrieb Michael Tokarev:
>> 11.02.2013 04:20, NeilBrown wrote:
>>> On Sat,  9 Feb 2013 18:48:38 +0100 Thomas B=E4chler
>>> <thomas@archlinux.org> wrote:
>>
>>>> -IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
>>>> +IMPORT{builtin}=3D"blkid"
>>
>> Does this has additional udev version constrain?
>> I mean, which is the minimum udev version to support this properly,
>> do we care?
>
> Udev relies on devtmpfs and thus does not create devices since versio=
n
> 176, therefore $tempnode is deprecated and only $devnode should be us=
ed
> ($tempnode seems to be around for compatibility, no idea if/when it w=
ill
> be dropped).
>
> The blkid builtin is also available since udev 176. In latest
> util-linux, the 'blkid -o udev' output is marked as deprecated, altho=
ugh
> Karel says it's not entirely going away for now.

Thank you for the explanation.

> Why do we care? We want correct udev rules ($tempnode vs. $devnode), =
and
> the using builtin is faster and less error-prone than calling an
> external tool (plus, it is used everywhere else in udev).
>
> As for compatibility: I see no reason why anyone would use a version =
of
> udev that is more than one year old (175) together with a mdadm versi=
on
> that is to be released in the future (3.2.7). If someone really wants
> that, they should be competent enough to adjust the udev rules for th=
eir
> local build.

Well, it was just a question.  Think about a distribution which is bein=
g
upgraded from one release to another, -- inter-package versioned depend=
encies
should be set correctly, so that the system will not be broken by upgra=
ding
mdadm which relies on udev, but not upgrading udev.  It's a good idea t=
o
note somewhere that the next release of mdadm will require at least ude=
v
175.  That's about it.

Thank you!

/mjt
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
