From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubt about raid1 and writemostly
Date: Wed, 1 Jul 2015 11:53:07 -0300
Message-ID: <CAH3kUhHV=RC-Q1bGG_OXPk=mUZ_Mc2T6h7KAQAv0GP-DMY-ihg@mail.gmail.com>
References: <CAH3kUhEdDY2DeAQ1FYaEvsRRdia9kn6V+9VQETxVdh9j-R3TTA@mail.gmail.com>
	<20150625085954.57b485ab@noble>
	<CAH3kUhHH+uNM92QGEocLJ3HmYYL-28ax1LuC2cvypAHkMYou0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHH+uNM92QGEocLJ3HmYYL-28ax1LuC2cvypAHkMYou0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i could do write-behind in a already up md device?
i'm trying echo writebehind > /sys/block/md0/md/dev-sdc1 and it return =
error

/sys/block/md0/md/dev-sdc1# echo write_behind >state
-bash: echo: write error: Invalid argument

2015-06-25 0:28 GMT-03:00 Roberto Spadim <roberto@spadim.com.br>:
> nice :)  i read about it some years ago and i was trying to remember,=
 i will
> test, thanks neil!
>
> 2015-06-24 19:59 GMT-03:00 NeilBrown <neilb@suse.com>:
>>
>> On Tue, 23 Jun 2015 12:01:33 -0300 Roberto Spadim
>> <roberto@spadim.com.br> wrote:
>>
>> > hi guys, i'm with a doubt
>> > when i use witemostly, how the md handle the slower drive
>> > (writemostly) for example i have 2 ssd that support 500mb/s write
>> > running raid1, i included a hdd with +- 100mb/s write with writemo=
stly
>> > flag
>> > when i execute a dd if=3D/dev/zero of=3D./test , i get near to 200=
mb/s
>> > with dd, and using iostat -d 1 -k, i get +- 100mb/s
>> > there's some kind of configuration to writemostly drive? something
>> > like 'buffer size' or someting like it?
>> >
>>
>> You need to also enable --write-behind if you want md/raid1 to not b=
e
>> slowed down so much by a slower device.
>> However this only really helps hide latency.  There is nothing that =
can
>> be done to help over-all throughput.
>>
>> When you set --write-behind you can provide a number which is the
>> number of outstanding requests that can be in flight to the
>> write-mostly device.
>>
>> If your writes are "bursty" in nature - so lots of writes together,
>> then longer pauses with no writes, then this write-behind buffer can
>> hide the delay caused by the slower device.  If you write continuous=
ly,
>> then there is no way that the slower device can keep up and the
>> over-all throughput will be reduced to match the slowest device.
>>
>> This functionality was originally written for cases where both devic=
es
>> had the same throughput, but one was higher latency, due to being
>> several kilometres away on the other end of an optical fibre.
>>
>> NeilBrown
>
>
>
>
> --
> Roberto Spadim
> SPAEmpresarial - Software ERP
> Eng. Automa=C3=A7=C3=A3o e Controle



--=20
Roberto Spadim
SPAEmpresarial - Software ERP
Eng. Automa=C3=A7=C3=A3o e Controle
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
