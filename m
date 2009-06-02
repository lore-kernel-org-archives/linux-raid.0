From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: Awful RAID5 random read performance
Date: Tue, 2 Jun 2009 07:57:16 -0700
Message-ID: <7a329d910906020757vec0de52xb6b7e4557e82c489@mail.gmail.com>
References: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com>
	 <200905312339.12234.tfjellstrom@shaw.ca>
	 <4A23CCF0.7030104@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A23CCF0.7030104@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: tfjellstrom@shaw.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 1, 2009 at 5:43 AM, Maurice Hilarius <maurice@harddata.com>=
 wrote:
> Thomas Fjellstrom wrote:
>>
>> ..
>> Yet I've heard NCQ makes some things worse. Some raid tweaking pages=
 tell
>> you to try disabling NCQ.
>>
>
> Not so relevant here.
> This recommendation to =C2=A0disable drive NCQ is generally due tot h=
e fact that
> NCQ implementations by various manufacturers tend
> to differ in behaviour, and, in some cases , is just plain "broken".

Not trying to start a flamewar on whos hardware is better, but I'd
love to get clarification on that last statement.  I've always been
under the impression Intel gets their NCQ right (works for me).  All
the reviews I've read on the current set of AMD southbridges indicate
they don't but I've no personal experience there.  No idea about
nvidia or the cheap add-in sata cards like Silicon Image.

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
