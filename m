From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 12:34:36 -0300
Message-ID: <BANLkTik8A0szuNk2HvDqQXpY3tSAdPoUKA@mail.gmail.com>
References: <20110506071752.GA22063@www2.open-std.org>
	<20110506133159.30c66519@natsu>
	<20110506090345.GA22245@www2.open-std.org>
	<4DC3BDD9.1060300@abpni.co.uk>
	<20110506094102.GC22245@www2.open-std.org>
	<20110506155059.6f82cbeb@natsu>
	<4DC3C804.6080200@abpni.co.uk>
	<iq0jv1$psl$1@dough.gmane.org>
	<20110506132739.GA22689@www2.open-std.org>
	<4DC3FF4C.5090502@meetinghouse.net>
	<20110506152405.GB22964@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506152405.GB22964@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum, i asked this question one time, the point is:
raid1 code is very easy
raid10 code is more complex

easy =3D faster, less memory, less cpu
complex =3D faster?, more memory? more cpu?

check others raid system (freebsd, netbsd) and check how they do...

2011/5/6 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Fri, May 06, 2011 at 10:01:48AM -0400, Miles Fidelman wrote:
>> Keld J=F8rn Simonsen wrote:
>> >>As you say, RAID10,near on four disks is pretty much identical to
>> >>RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
>> >>
>>
>> I don't that's exactly right. =A0At least as I understand it:
>>
>> - RAID1+0 (and RAID0+1) nests things - you start with two sets of RA=
ID1
>> mirrors, then stripe across them (or vice versa) - it's a nested set=
 of
>> steps
>>
>> - md RAID10 provides both mirroring and striping, but it's a more
>> integrated function - (from the man page) "RAID10 provides a combina=
tion
>> of RAID1 and RAID0, and sometimes known as RAID1+0. Every datablock =
is
>> duplicated some number of times, and the resulting collection of
>> datablocks are distributed over multiple drives." - but there isn't =
an
>> inherent nesting in the process (i.e., no two disks are copies of ea=
ch
>> other, and md RAID10 will work over odd numbers of drives)
>
> Yes, you are right, RAID1+0 is nested, while Linux MD raid10 is not.
> But the data layout of Linux MD RAID1+0 and Linux MD
> RAID10,near is almost identical.
>
> keld
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
