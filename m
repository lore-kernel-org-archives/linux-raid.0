From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 12:23:12 -0400
Message-ID: <4DC42070.2070401@meetinghouse.net>
References: <20110506071752.GA22063@www2.open-std.org>	<20110506133159.30c66519@natsu>	<20110506090345.GA22245@www2.open-std.org>	<4DC3BDD9.1060300@abpni.co.uk>	<20110506094102.GC22245@www2.open-std.org>	<20110506155059.6f82cbeb@natsu>	<4DC3C804.6080200@abpni.co.uk>	<iq0jv1$psl$1@dough.gmane.org>	<20110506132739.GA22689@www2.open-std.org>	<4DC3FF4C.5090502@meetinghouse.net>	<20110506152405.GB22964@www2.open-std.org> <BANLkTik8A0szuNk2HvDqQXpY3tSAdPoUKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik8A0szuNk2HvDqQXpY3tSAdPoUKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roberto Spadim wrote:
> hum, i asked this question one time, the point is:
> raid1 code is very easy
> raid10 code is more complex
>
> easy =3D faster, less memory, less cpu
> complex =3D faster?, more memory? more cpu?
>
> check others raid system (freebsd, netbsd) and check how they do...
>
> 2011/5/6 Keld J=F8rn Simonsen<keld@keldix.com>:
>   =20
>>> Keld J=F8rn Simonsen wrote:
>>>       =20
>>>>> As you say, RAID10,near on four disks is pretty much identical to
>>>>> RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
>>>>>
>>>>>           =20

of course RAID10 offers the far option, and the option to run on an odd=
=20
number of drives (I currently use it on a couple of 4-drive servers, bu=
t=20
as I  look at some replacement hardware I've been thinking that RAID10=20
on a 5-drive configuration offers a nice mix of reliability and perform=
ance)

re. easy/complex - I'm not sure I really believe that - when I've=20
reviewed options, I come to the conclusion that:

RAID1 - wastes a lot of drive space, particularly if you want to=20
maintain reliability after a single-drive failure (requires a minimum o=
f=20
3 mirrored drives)

RAID5 and RAID6 are better when it comes to mixing efficiency with=20
multi-drive failures, but have a couple of odd failure modes and are a=20
real pain to rebuild after a failure

RAID1+0 and RAID0+1 are interesting combination - but my sense is that=20
every time you nest a layer, you're adding configuration complexity,=20
processing delays (low level cpu cycles and i/o transactions), and just=
=20
that much more complexity if you have to reconfigure or rebuild and=20
array (particularly if you're running LVM and DRBD on top of the basic=20
disk arrays, as I am)

md RAID10 chops out a layer of nesting and makes better use of disk=20
space - by combining block replication and striping into a single layer=
=20
- providing what, to me, is a good balance of disk use, multiple copies=
=20
of data, performance, and managability - so far, its worked well for me



--=20
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
