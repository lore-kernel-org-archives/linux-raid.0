From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: debian software raid1
Date: Tue, 19 Apr 2011 23:05:27 +0100
Message-ID: <BANLkTik02c1OOvq8TBisfo4+KXFBCgNKzA@mail.gmail.com>
References: <1303215166.2809.8.camel@valio>
	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
	<4DADB24F.2030300@cdf.toronto.edu>
	<alpine.DEB.2.00.1104192148270.4097@unicorn.drogon.net>
	<4DADFFC5.3090009@crc.id.au>
	<BANLkTin8MgBDixExj+qygshM_oMjTS1emg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTin8MgBDixExj+qygshM_oMjTS1emg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 April 2011 23:01, Roberto Spadim <roberto@spadim.com.br> wrote:
> hum, some doubts....
> what=C2=B4s better (faster / secure)?
> swap over one disk (no raid)
> swap over one md raid1
> swap over one md raid0
> swap over one md raid10
> swap over one md raid5
> swap over one md raid6
>
>
>
> 2011/4/19 Steven Haigh <netwiz@crc.id.au>:
>> On 20/04/2011 7:10 AM, Gordon Henderson wrote:
>>>
>>> I'm actually of the opinion that to NOT put swap on RAID in an othe=
rwise
>>> RAIDed system is just plain silly. Do it. You know it makes sense!
>>
>> I think the preferred method at the moment (and at least for 2010/20=
11) is
>> to have a smallish RAID1 partition for /boot then create a second RA=
ID array
>> for everything else and use LVM on top of that.
>>
>> That allows you to have the host on the same RAID1 and use the flexi=
bility
>> to use LVM for all your other requirements.
>>
>> I personally run a Xen virtualisation server - it has the following:
>> /dev/md0 - /boot - 512Mb - RAID1
>> /dev/md1 - VG 'RAID1' - rest of disk - RAID1
>> /dev/md2 - VG 'RAID5' - 3 x 1Tb whole disks - RAID5
>>
>> Then the majority of the 7 VMs on that machine live on the RAID5 VG =
(with
>> one special case that is on the RAID1 VG) and it runs very happily.
>>
>> The swap and root of Dom0 is on the RAID1 VG. This seems to be the b=
est way
>> I've found to have the most flexibility and not have to change thing=
s as
>> time progresses.
>>
>> --
>> Steven Haigh
>>
>> Email: netwiz@crc.id.au
>> Web: http://www.crc.id.au
>> Phone: (03) 9001 6090 - 0412 935 897
>> Fax: (03) 8338 0299
>>
>> There are no great men, only great challenges that ordinary men are =
forced
>> by circumstances to meet. -- Admiral William Halsey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

You can't say "faster/secure", it's mostly either one. Swap over raid0
or some raid10 implementation would probably be the fastest. Swap on
raid456 would be incredibly slow write wise...
// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
