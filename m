From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: Re: raid1 w/ 3 active mirrors?
Date: Mon, 30 May 2005 11:15:55 -0700
Message-ID: <429B585B.1000305@bitzi.com>
References: <429A13BC.2090809@bitzi.com> <429A1DF8.6050409@tls.msk.ru> <429A2E11.2070002@bitzi.com> <429AA530.2040702@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429AA530.2040702@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@apartia.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Laurent CARON wrote:
> Gordon Mohr (@ Bitzi) a =E9crit :

>> How do you make all the disks active mirrors? When I add a third=20
>> partition
>> to an functioning RAID1 array (mdadm -a), it always enters as a=20
>> 'spare'. Only
>> after another disk fails out will it be brought into sync with the=20
>> remaining
>> active partition.
>>
>> (I'd like the third partition to be brought into sync, and kept in s=
ync,
>> with the other two immediately, so that a fail does not trigger any
>> flurry of activity.)

> when you create the array:
>=20
> mdadm -Cv /dev/md0 -l1 -n10 /dev/sd{a,b,c,d,e,f,g,h,i,j}1

Thanks for the tip.

I'm hoping to do this to a prexisting array, so I'll probably need
to use --grow rather than -C together with -n/--raid-devices, but
you've pointed me in the right direction and I'll try this soon.

Merci!

- Gordon @ Bitzi
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
