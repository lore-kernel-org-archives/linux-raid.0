From: Asif Iqbal <vadud3@gmail.com>
Subject: Re: Failing to grow raid10 with one larger disk
Date: Thu, 24 Jan 2013 20:02:30 -0500
Message-ID: <CAOHBbgVizy_LTyOaT=WUyPbFjOOLLxRFnMT3hYWPF5cVmRpHJg@mail.gmail.com>
References: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com>
 <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 24, 2013 at 7:43 PM, Mathias Bur=E9n <mathias.buren@gmail.c=
om> wrote:
> On 25 January 2013 00:33, Asif Iqbal <vadud3@gmail.com> wrote:
>> Replaced one of the 6 72G disks from raid10 with a 300G disk.
>>
>> But failing to grow the md10
>>
>> # mdadm --grow /dev/md10 --size max
>> mdadm: raid10 array /dev/md10 cannot be reshaped.
>>
>> What gives?
>>
>> --
>> Asif Iqbal
>> PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
>> A: Because it messes up the order in which people normally read text=
=2E
>> Q: Why is top-posting such a bad thing?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> What did you expect?
>

I was hoping to grow the size of the raid10.

I was following this link

https://raid.wiki.kernel.org/index.php/Growing#Expanding_existing_parti=
tions

> Mathias



--
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
