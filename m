From: CoolCold <coolthecold@gmail.com>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 31 Aug 2011 17:16:25 +0400
Message-ID: <CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5E2F7D.1010306@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Paul Clements <paul.clements@us.sios.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 31, 2011 at 4:56 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 31/08/2011 13:30, Paul Clements wrote:
>>
>> On Wed, Aug 31, 2011 at 5:05 AM, CoolCold<coolthecold@gmail.com> =A0=
wrote:
>>
>>>> root@gamma2:~# cat /proc/mdstat
>>>> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>>>> md3 : active raid1 sdc3[1] sdb3[0]
>>>> =A0 =A0 =A01443552640 blocks [2/2] [UU]
>>>> =A0 =A0 =A0bitmap: 16/22 pages [64KB], 32768KB chunk
>>
>>> More details now:
>>> Array still has 16/22 dirty pages:
>>
>>> root@gamma2:~# mdadm --examine-bitmap /dev/sdc3
>>
>>> =A0 =A0 =A0 Sync Size : 1443552640 (1376.68 GiB 1478.20 GB)
>>> =A0 =A0 =A0 =A0 =A0Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
>>
>> But only 189 bits dirty. This means the bits are just distributed
>> across the disk (which is why you have 16/22 pages dirty).
>>
>> Any activity on the disk? 189 bits could easily be explained by a
>> small amount of background disk activity on a disk that big.
>
> That makes sense to me. I have:
>
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md1 : active raid6 sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
> =A0 =A0 =A02929966080 blocks level 6, 512k chunk, algorithm 2 [5/5] [=
UUUUU]
> =A0 =A0 =A0bitmap: 2/4 pages [8KB], 131072KB chunk
>
> Oh no! Half my array is dirty! But then:
>
> # mdadm --examine-bitmap /dev/sdb2
> =A0 =A0 =A0 =A0Filename : /dev/sdb2
> =A0 =A0 =A0 =A0 =A0 Magic : 6d746962
> =A0 =A0 =A0 =A0 Version : 4
> =A0 =A0 =A0 =A0 =A0 =A0UUID : d8c57a89:166ee722:23adec48:1574b5fc
> =A0 =A0 =A0 =A0 =A0Events : 1338800
> =A0Events Cleared : 1338800
> =A0 =A0 =A0 =A0 =A0 State : OK
> =A0 =A0 =A0 Chunksize : 128 MB
> =A0 =A0 =A0 =A0 =A0Daemon : 5s flush period
> =A0 =A0 =A0Write Mode : Normal
> =A0 =A0 =A0 Sync Size : 976655360 (931.41 GiB 1000.10 GB)
> =A0 =A0 =A0 =A0 =A0Bitmap : 7452 bits (chunks), 7 dirty (0.1%)
>
> Not so bad after all.
Makes sense, but...

>
> On the other hand, repeatedly checking /proc/mdstat shows different n=
umbers
> of pages being dirty, and --examine-bitmap shows different numbers of=
 bits
> being dirty each time, whereas CoolCold managed 16 pages repeatedly a=
nd 189
> bits being dirty twice in a row. CoolCold, please can you test
> --examine-bitmap again several times at least 5 seconds apart?

fast test with "sleep 5" reveals:
root@gamma2:~# for i in {1..20};do mdadm --examine-bitmap
/dev/sdc3|grep "Bitmap :";sleep 5;done
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
          Bitmap : 44054 bits (chunks), 189 dirty (0.4%)

And 16/22 lasts for 4 days.

>
> Cheers,
>
> John.
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
