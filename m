From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Tue, 5 Feb 2008 11:54:27 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>
References: <20080130192133.17b254bf@szpak> <20080130220007.GG20173@rap.rap.dk> <20080130233639.5d46b044@szpak> <20080131015506.GB6617@rap.rap.dk> <20080205161036.GA30326@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1449706023-1202230467=:9790"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205161036.GA30326@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1449706023-1202230467=:9790
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 5 Feb 2008, Keld J=F8rn Simonsen wrote:

> On Thu, Jan 31, 2008 at 02:55:07AM +0100, Keld J=F8rn Simonsen wrote:
>> On Wed, Jan 30, 2008 at 11:36:39PM +0100, Janek Kozicki wrote:
>>> Keld J=F8rn Simonsen said:     (by the date of Wed, 30 Jan 2008 23:00:0=
7 +0100)
>>>
>>
>> All the raid10's will have double time for writing, and raid5 and raid6
>> will also have double or triple writing times, given that you can do
>> striped writes on the raid0.
>
> For raid5 and raid6 I think this is even worse. My take is that for
> raid5 when you write something, you first read the chunk data involved,
> then you read the parity data, then you xor-subtract the data to be
> changed, and you xor-add the new data, and then write the new data chunk
> and the new parity chunk. In total 2 reads and 2 writes. The read/writes
> happen on the same chunks, so latency is minimized. But in essence it is
> still 4 IO operations, where it is only 2 writes on raid1/raid10,
> that is only half the speed for writing on raid5 compared to raid1/10.
>
> On raid6 this amounts to 6 IO operations, resulting in 1/3 of the
> writing speed of raid1/10.
>
> I note in passing that there is no difference between xor-subtract and
> xor-add.
>
> Also I assume that you can calculate the parities of both raid5 and
> raid6 given the old parities chunks and the old and new data chunk.
> If you have to calculate the new parities by reading all the component
> data chunks this is going to be really expensive, both in IO and CPU.
> For a 10 drive raid5 this would involve reading 9 data chunks, and
> making writes 5 times as expensive as raid1/10.
>
> best regards
> keld
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

On my benchmarks RAID5 gave the best overall speed with 10 raptors,=20
although I did not play with the various offsets/etc as much as I have=20
tweaked the RAID5.

Justin.
---1463747160-1449706023-1202230467=:9790--
