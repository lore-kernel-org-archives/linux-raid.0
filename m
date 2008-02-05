From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Tue, 5 Feb 2008 17:58:56 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802051758010.15698@p34.internal.lan>
References: <20080130192133.17b254bf@szpak> <20080130220007.GG20173@rap.rap.dk> <20080130233639.5d46b044@szpak> <20080131015506.GB6617@rap.rap.dk> <20080205161036.GA30326@rap.rap.dk> <alpine.DEB.1.00.0802051152500.9790@p34.internal.lan> <20080205200423.GB17621@rap.rap.dk>
 <alpine.DEB.1.00.0802051726510.10352@p34.internal.lan> <20080205225534.GA32053@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1565307494-1202252336=:15698"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205225534.GA32053@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1565307494-1202252336=:15698
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 5 Feb 2008, Keld J=F8rn Simonsen wrote:

> On Tue, Feb 05, 2008 at 05:28:27PM -0500, Justin Piszcz wrote:
>>
>>
>>> Could you give some figures?
>>
>> I remember testing with bonnie++ and raid10 was about half the speed
>> (200-265 MiB/s) as RAID5 (400-420 MiB/s) for sequential output, but inpu=
t
>> was closer to RAID5 speeds/did not seem affected (~550MiB/s).
>
> Impressive. What levet of raid10 was involved? and what type of
Like I said, it was baseline testing, so pretty much the default raid10=20
when you create it via mdadm, I did not mess with offsets, etc.

> equipment, how many disks?
Ten 10,000rpm raptors.

> Maybe the better output for raid5 could be
> due to some striping - AFAIK raid5 will be striping quite well, and
> writes almost equal to reading time indicates that the writes are
> striping too.
>
> best regards
> keld
>
---1463747160-1565307494-1202252336=:15698--
