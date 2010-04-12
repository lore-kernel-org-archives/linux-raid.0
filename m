From: =?ISO-8859-15?Q?Tom=E1=A8_Dul=EDk?= <dulik@unart.cz>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 09:43:16 +0200
Message-ID: <4BC2CF14.9000209@unart.cz>
References: <loom.20100411T185315-118@post.gmane.org> <4BC29670.6020504@unart.cz> <4BC2B887.6020403@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC2B887.6020403@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stefan /*St0fF*/ H=FCbner napsal(a):
> I cannot quite understand your problem.  As every part of the array
> contains it's own metadata, it doesn't matter to md which /dev/sdX a
> drive is.  It might matter a bit for boot-time assembly, but actually
> that's what UUIDs are for.
>  =20
I know how UUIDs work.
My problem with device names is not a "critical", it's about "user=20
friendliness" of the physical disk management.
If a disk fails and I receive email "A Fail event had been detected on=20
md device /dev/md2. It could be related to component device /dev/sdd3",=
=20
how will I know which disk should be replaced, if the device name is no=
t=20
fixed/persistent? Is it the disk in the first bay, or the second? Aside=
=20
of the solution documented on the wiki page, I could also use try a=20
simpler one based on the idea here:
http://www.outsidaz.org/blog/2009/11/05/identifying-failed-drives-via-u=
dev-and-mdadm/

But for the disk management purposes, I prefer having the disk names=20
fixed according the the disk bay position. So disk in bay nr. 1 is=20
/dev/sda, bay nr. 2 is /dev/sdb, etc.

The wiki page I created is just about this. I haven't found any documen=
t=20
like this anywhere else, so if it helps someone, I'll be glad.

Tom
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
