From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about raid robustness when disk fails
Date: Tue, 26 Jan 2010 08:29:53 +0100
Message-ID: <87hbq9s4r2.fsf@frosties.localdomain>
References: <1262972385.8962.159.camel@kije>
	<87hbqeyua9.fsf@frosties.localdomain> <1264436547.3015.24.camel@kije>
	<87636qqdia.fsf@frosties.localdomain>
	<1264443165.30742.73.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264443165.30742.73.camel@test.apertos.eu> (Micha's message of
	"Mon, 25 Jan 2010 19:12:45 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Micha Sawicz <michal@sawicz.net>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Micha=C5=82 Sawicz <michal@sawicz.net> writes:

> Dnia 2010-01-25, pon o godzinie 18:51 +0100, Goswin von Brederlow pis=
ze:
>> The only values I would keep a close eye on is remapped sectors and
>> pending sectors. Anything else gives nice graphs but I always feel i=
s
>> totaly useless. And even the pending sectors are !=3D 0 on one drive
>> while
>> badblocks reports no errors on repeated passes. The drive just doesn=
't
>> seem to reduce the count when it successfully remaps a sector.=20
>
> I read today that Samsungs show that behavior. Maybe this is the case=
?

I usualy buy one or at most 2 new disks at a time so my drives are all
different makes and models. Might verry well be a samsung drive that ha=
s
that behaviour.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
