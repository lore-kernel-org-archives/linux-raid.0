From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Sat, 13 Nov 2004 20:28:10 +0000
Message-ID: <41966E5A.8070308@dgreaves.com>
References: <200411121847.iACIlNN01272@www.watkins-home.com> <41966514.8000301@dgreaves.com> <yw1xwtwpjz6e.fsf@ford.inprovide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1xwtwpjz6e.fsf@ford.inprovide.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

M=E5ns Rullg=E5rd wrote:

>David Greaves <david@dgreaves.com> writes:
>
> =20
>
>>Now, Guy, your next step:
>># mdadm --assemble --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/hdb1
>>mdadm: /dev/sda1 does not appear to be an md device
>>   =20
>>
>
>Sorry to butt in,
>
=46eel free - and thanks :)

> but that command should, assuming the components are
>correct, read as
>
>mdadm --assemble <raiddevice> --force /dev/sda1 /dev/sdb1 /dev/sdc1 /d=
ev/hdb1
>
>with <raiddevice> replaced by something like /dev/md0.
>
> =20
>
indeed it should.
I don't know if that's why mdadm gave that message.

I'm still re-copying the partition so I'll try it again when I'm done=20
(an hour or so left)

Thanks
David

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
