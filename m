From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 14:54:50 +0200
Message-ID: <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com> <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org> <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org> <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de> <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424123706.GA6798@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-24 14:37 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Mon, Apr 24, 2017 at 02:13:24PM +0200, Patrik Dahlstr=C3=B6m wrote:
>> I'm afraid it doesn't say that.
>
> You said you found an ext header in the raw data.
Yes, I found ext headers in both /dev/sda and /dev/sdf, but it doesn't
show up in the 6 disk raid (/dev/md1).
>
> If that exists then only thing I can think of is that you ended
> up picking the wrong offset (or disk order) after all.
What offset are you referring to here? The --data-offset to the mdadm
--create command?

>
>> I do know that both raids contains only zeros for
>> many MB before any data appears.
>
> This could be normal for the 5disk array since that part already
> reshaped and the offset changed and there just could happen to
> be zeroes somewhere in the beginning of a filesystem after the
> first block of metadata.
Makes sense
>
> Basically the 5disk array is supposed to have bogus data at
> the start in your case. But it should turn into valid data
> at whatever point the reshape did not yet reach.
Should I then be able to find a copy of ext4 superblock in the 5 disk
array once valid data start to appear?
>
> This bogus data makes it hard to determine the correct offset
> but according to the output you showed before the offset should
> be 128M here.
I found out that there existed a ext4 file system at offset 0x7B80000
(123,5 MB) on both /dev/sda and /dev/sdb. I will adjust my mdadm
--create commands to this offset when I get home and try again.
>
> For the 6disk array you should see valid data (starting with
> the filesystem header) for however far the reshape was already done.
> Depending on how the filesystem works you might even be able to
> mount it but everything that is located behind the progress point
> would appear corrupted.
Interesting. Like I said above, I will retry the create commands with
123.5 MB --data-offset.
>
> Again if one of the disks actually was kicked from the array
> while the grow was going on, you should leave that disk out as missing
> as otherwise it will just appear as wrong data in both arrays.
I don't think the disk was ever kicked out. The kernel reset the link
and continued, I believe.
>
> Regards
> Andreas Klauer
>
Best regards
Patrik Dahlstr=C3=B6m
