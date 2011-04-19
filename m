From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: debian software raid1
Date: Tue, 19 Apr 2011 19:01:08 -0300
Message-ID: <BANLkTin8MgBDixExj+qygshM_oMjTS1emg@mail.gmail.com>
References: <1303215166.2809.8.camel@valio>
	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
	<4DADB24F.2030300@cdf.toronto.edu>
	<alpine.DEB.2.00.1104192148270.4097@unicorn.drogon.net>
	<4DADFFC5.3090009@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DADFFC5.3090009@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum, some doubts....
what=B4s better (faster / secure)?
swap over one disk (no raid)
swap over one md raid1
swap over one md raid0
swap over one md raid10
swap over one md raid5
swap over one md raid6



2011/4/19 Steven Haigh <netwiz@crc.id.au>:
> On 20/04/2011 7:10 AM, Gordon Henderson wrote:
>>
>> I'm actually of the opinion that to NOT put swap on RAID in an other=
wise
>> RAIDed system is just plain silly. Do it. You know it makes sense!
>
> I think the preferred method at the moment (and at least for 2010/201=
1) is
> to have a smallish RAID1 partition for /boot then create a second RAI=
D array
> for everything else and use LVM on top of that.
>
> That allows you to have the host on the same RAID1 and use the flexib=
ility
> to use LVM for all your other requirements.
>
> I personally run a Xen virtualisation server - it has the following:
> /dev/md0 - /boot - 512Mb - RAID1
> /dev/md1 - VG 'RAID1' - rest of disk - RAID1
> /dev/md2 - VG 'RAID5' - 3 x 1Tb whole disks - RAID5
>
> Then the majority of the 7 VMs on that machine live on the RAID5 VG (=
with
> one special case that is on the RAID1 VG) and it runs very happily.
>
> The swap and root of Dom0 is on the RAID1 VG. This seems to be the be=
st way
> I've found to have the most flexibility and not have to change things=
 as
> time progresses.
>
> --
> Steven Haigh
>
> Email: netwiz@crc.id.au
> Web: http://www.crc.id.au
> Phone: (03) 9001 6090 - 0412 935 897
> Fax: (03) 8338 0299
>
> There are no great men, only great challenges that ordinary men are f=
orced
> by circumstances to meet. -- Admiral William Halsey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
