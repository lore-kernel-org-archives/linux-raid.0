From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 10:01:48 -0400
Message-ID: <4DC3FF4C.5090502@meetinghouse.net>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu> <4DC3C804.6080200@abpni.co.uk> <iq0jv1$psl$1@dough.gmane.org> <20110506132739.GA22689@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506132739.GA22689@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
>> As you say, RAID10,near on four disks is pretty much identical to
>> RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
>>     =20

I don't that's exactly right.  At least as I understand it:

- RAID1+0 (and RAID0+1) nests things - you start with two sets of RAID1=
=20
mirrors, then stripe across them (or vice versa) - it's a nested set of=
=20
steps

- md RAID10 provides both mirroring and striping, but it's a more=20
integrated function - (from the man page) "RAID10 provides a combinatio=
n=20
of RAID1 and RAID0, and sometimes known as RAID1+0. Every datablock is=20
duplicated some number of times, and the resulting collection of=20
datablocks are distributed over multiple drives." - but there isn't an=20
inherent nesting in the process (i.e., no two disks are copies of each=20
other, and md RAID10 will work over odd numbers of drives)

Miles Fidelman




--=20
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
