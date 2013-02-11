From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/2] Modernize udev rules
Date: Mon, 11 Feb 2013 12:33:37 +0400
Message-ID: <5118ACE1.5020503@msgid.tls.msk.ru>
References: <1360432119-15910-1-git-send-email-thomas@archlinux.org> <20130211112016.3059ef95@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130211112016.3059ef95@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

11.02.2013 04:20, NeilBrown wrote:
> On Sat,  9 Feb 2013 18:48:38 +0100 Thomas B=C3=A4chler <thomas@archli=
nux.org> wrote:

>> -IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
>> +IMPORT{builtin}=3D"blkid"

Does this has additional udev version constrain?
I mean, which is the minimum udev version to support this properly,
do we care?

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
