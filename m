From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Recommended sw raid setup
Date: Sat, 2 Jul 2011 14:17:17 -0700
Message-ID: <BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>
	<BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com>
	<CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: John Obaterspok <john.obaterspok@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I thought that I had read the TLER was not useful for mdraid, so that
enterprise drives were not really advised for mdraid. Am I wrong about
this?

Also, for the original question: for a home system, do you really need
the uptime  that RAID provides? I suspect not -- in that case, put
your money into backups, not RAID.

Simon

On Sat, Jul 2, 2011 at 12:45 PM, Drew <drew.kay@gmail.com> wrote:
> Hi John,
>
> Personally I think you'd be fine with consumer grade drives. Put them
> in a RAID-5 array and you should be set.
>
> The high end consumer & enterprise stuff w/ TLER and the like is only
> really needed if you put a lot of demand on the disks, running virtua=
l
> machines for example. A basic file server for home use won't stress
> the drives enough to need the more expensive ones.
>
>
> -Drew
>
> On 07/02/2011, John Obaterspok <john.obaterspok@gmail.com> wrote:
>> Hi,
>>
>> I've going to setup a _home_ file server to store all photos & famil=
y
>> videos, work related material, DNLA streaming=A0and more.
>>
>> The server will be set to suspend when not in use for an hour or so.
>>
>> I've been thinking about buying 3 x 3 TB SATA disks and put these in
>> software RAID5 (except for a smaller boot partition on all three dis=
ks
>> which will be RAID1).
>>
>> Any recommendation for what SATA drives to get? Should I get
>> enterprise drives that support TLER (or alike), or will the greener
>> low cost drives be enough, is there something in between?
>>
>> Is it better to buy 4 low cost drives in RAID1 or 3 enterprise drive=
s in
>> RAID5?
>>
>> Please help, I'm completely lost!
>>
>> --john
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
> Sent from my mobile device
>
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
>
> "This started out as a hobby and spun horribly out of control."
> -Unknown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
