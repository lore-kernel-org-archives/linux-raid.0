From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: "raid array not clean" messages
Date: Thu, 21 May 2009 10:19:43 +0530
Message-ID: <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: fibre raid <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

On Thu, May 21, 2009 at 10:06 AM, fibre raid <fibreraid@gmail.com> wrot=
e:
> Hi,
>
> Right now, whenever a parity RAID (like raid5 or raid6) is created,
> something (md itself or mdadm) is dumping a message to the console
> about "raid array not clean, background synchronization...". I want t=
o
> disable these messages but cannot find a way to do so. Can you advise=
?
> thanks!
>

Do you mean creating a new array or assembling an existing one ?

AFAIK,
You can get this message when you are assimilating an existing array
if you array is not clean and needs recovery.

But ideally you should not get this when creating a new array.
> -Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
