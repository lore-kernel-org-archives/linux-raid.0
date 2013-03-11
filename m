From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 20:41:35 +0100
Message-ID: <CAAnFQG-FJo_2UDX-ws_TCUM5mpJAkMQtyJC_MUZNqUSQpnWj+Q@mail.gmail.com>
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

> I see read failures on the SMART self tests, that warrants an RMA. So=
,
> get that done. A faulty SATA cable would not do that, you'd rather se=
e
> CRC errors or other kernel log messages.

All right, tomorrow I will request an RMA.

One of the drives only shows one sector bad. I hope I can still get
some/most of my data.

I know that forcing a reassembly lets me mount the filesystem although
at certain point causes a kernel backtrace and I believe most data is
unreadable.

How should I proceed to be able to get most of the data? Will I have
to create a completely new array or can I somehow fix it adding new
disks?

Oh and thanks a lot for the help, I'm still a newbie with raids.


--=20
Javier Marcet <jmarcet@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
