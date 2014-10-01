From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 - ssd, doubts
Date: Tue, 30 Sep 2014 23:01:41 -0300
Message-ID: <CAH3kUhFpmdm2oxsOVLpEUxfNN06PhwmVD1wkRMMpQcJ7Qyb6RA@mail.gmail.com>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
	<FA95F377-79D3-4DF7-8B41-D7BB1B706660@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FA95F377-79D3-4DF7-8B41-D7BB1B706660@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

humm interesting , just mdraid1 work with trim :)

other doubt now.. when using ssd+hdd, should trim be enabled at filesys=
tem?

2014-09-30 21:36 GMT-03:00 Brassow Jonathan <jbrassow@redhat.com>:
>
> On Sep 30, 2014, at 9:50 AM, Roberto Spadim wrote:
>> the point are: madm raid1 trim is supported? or should i use lvm?
>> should i partition it with 400gb and leave 100gb untouched? or shoul=
d
>> i use a hdd+ssd and dmcache?
>
> LVM does not yet support trim on RAID.  (Funny you should ask!  We've=
 just been talking about enabling this in LVM recently and it should go=
 upstream very soon - following into the various distros a little later=
=2E)
>
>  brassow



--=20
Roberto Spadim
SPAEmpresarial
Eng. Automa=C3=A7=C3=A3o e Controle
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
