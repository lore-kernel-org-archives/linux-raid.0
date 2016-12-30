From: Doug Dumitru <doug@easyco.com>
Subject: Re: Intel SSD or other brands
Date: Fri, 30 Dec 2016 10:23:22 -0800
Message-ID: <CAFx4rwQb45iRrqwo6JU0N54JxJiixWYdMhBepZ4YC5gBsv6nSg@mail.gmail.com>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
 <CAFx4rwT+j3mx3B_bj803Zs1kX=x-1w4Nwwsyb=a=NumFo8-Ufw@mail.gmail.com>
 <6199a648-eebe-687d-1a13-3f2dd954ae54@websitemanagers.com.au>
 <CAFx4rwRUnfCXgM66oa+-GYbtthVZvtHQkb2-J3XqUU9YXWF6sA@mail.gmail.com> <20161230163210.GW28824@reaktio.net>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161230163210.GW28824@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Pasi,

The software is proprietary, but can run on most 64-bit Linux systems
in a server setting.  It also works wonders with "embedded Flash" (SD,
eMMC, USB, etc.) for 32-bit x86 and ARM systems.

Please send me a direct email, off-list, and I can give you more details.

Doug Dumitru

On Fri, Dec 30, 2016 at 8:32 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> w=
rote:
> Hello,
>
> On Thu, Dec 29, 2016 at 05:24:16PM -0800, Doug Dumitru wrote:
>>
>> My test is of a "managed" array with a "host side Flash Translation
>> Layer".  This means that software is linearizing the writes before
>> RAID-5 sees them.  This is how the major "storage appliance" vendors
>> get really fast performance.  One vendor, running an earlier version
>> of the software I am running here, was able to support 5000 ESXI VDI
>> clients from a single 2U storage server (with a lot of FC cards).  The
>> boot storm took about 3 minutes to settle.
>>
>
> Does this software happen to be opensource / publicly available ?
>
>
> Thanks,
>
> -- Pasi
>
>> Single drives are around 500 MB/sec which is 125K IOPS through our
>> engine.  Eight drives are (8-1)x500=3D3500 MB/sec or 900K IOPS.  This is
>> actually faster than FIO can generate a test pattern from a single
>> job.  It is also faster than stock RAID-5 can linearly write without
>> patches.
>>
>> In terms of wear, lots of users are running very light write
>> environments.  This is good as many configurations are > 50:1 write
>> amp if you measure "end to end".  By end to end, I mean, how many
>> flash writes happen when you create a small file inside of a file
>> system.  This leads to "file system write amp" x "raid write amp" x
>> "SSD write amp".  Some people don't like this approach as the file
>> system is often "off limits" and a black box.  Then again, some file
>> systems are better than others (for 10K sync creates, EXT4 and XFS are
>> both about 4.4:1 whereas ZFS is a lot worse).  And with EXT4/XFS, you
>> can mitigate some of this with an SSD or mapping layer that compresses
>> blocks.
>>
>> Doug Dumitru
>>
>



--=20
Doug Dumitru
EasyCo LLC
