From: Asif Iqbal <vadud3@gmail.com>
Subject: Re: Failing to grow raid10 with one larger disk
Date: Thu, 24 Jan 2013 20:22:20 -0500
Message-ID: <CAOHBbgUbbxWZh2TM5m+o6ULHxctGPOs55mK3sKrX8A-D5UKJCg@mail.gmail.com>
References: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com>
 <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com>
 <CAOHBbgVizy_LTyOaT=WUyPbFjOOLLxRFnMT3hYWPF5cVmRpHJg@mail.gmail.com> <5101DB37.7030407@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5101DB37.7030407@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 24, 2013 at 8:09 PM, Brad Campbell <brad@fnarfbargle.com> wrote:
> On 25/01/13 09:02, Asif Iqbal wrote:
>>
>> I was hoping to grow the size of the raid10. I was following this link
>> https://raid.wiki.kernel.org/index.php/Growing#Expanding_existing_partitions
>
>
> Re-read the second sentence on the first line of that page.

doh! so I can only grow raid level 1/4/5/6

ok, can you suggest how can I increase the /dir (/dev/md10) with bigger disks?

I already backed up the data.

does linux software raid allow disks of different sizes in raid10? I
did not see much discussion
of raid level 10 in that wiki page.

--
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
