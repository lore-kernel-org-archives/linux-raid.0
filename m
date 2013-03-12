From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Tue, 12 Mar 2013 19:55:29 +0100
Message-ID: <CAAnFQG_mJEAa=nPTOm0n7pjX7g8saLRTEtm-FDhP5+MYOOsH5Q@mail.gmail.com>
References: <CAAnFQG8Ca7fkr-vboobr_qmRMTn38U9QP5hiT-9Ps0BqWcunzw@mail.gmail.com>
 <29375201.0.1362994874930.JavaMail.root@zimbra> <CAAnFQG__hwROJG1mE9BAaoapUDXTos+52udEp0yc6SfQz==DKA@mail.gmail.com>
 <CADNH=7E0788eV7zZKbWao4n1+WEMCcaX9sp7MkBgsCKrLmocSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7E0788eV7zZKbWao4n1+WEMCcaX9sp7MkBgsCKrLmocSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 11, 2013 at 8:26 PM, Mathias Bur=C3=A9n <mathias.buren@gmai=
l.com> wrote:

>>>> > As above. Also, I see no self-tests logged?
>>>>
>>>> I hadn't done any test manually but I had smartd running and
>>>> configured.
>>>
>>> smartd won't run any tests unless you configure it to do so.
>>
>> I completely forgot to check the surfaces when I bought the disks. I
>> did quite a few tests before I decided to use ext4 but did not check
>> their health.
>>
>> I have two disks still missing 30% of the long test but the two othe=
r
>> ones stopped due to errors:
>>
>> http://bpaste.net/raw/83003/
>> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
>> Always       -       18
>>
>> http://bpaste.net/raw/83004/
>> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
>> Always       -       1
>>
>>
>> I am gonna pass badblocks on them but this does not look good.
>>
>> Could a faulty sata data cable cause those bad blocks? The disks are=
 8
>> months old so I hope I can get them replaced.

I have filed the RMAs and ordered a new disk so that I can at least
copy some of the data. Yet I have been thinking I could clone the
drive which is still part of the array and has one bad sector over the
new one and try to assemble the raid with the clone.

Could that work?


--=20
Javier Marcet <jmarcet@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
