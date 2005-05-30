From: Laurent CARON <lcaron@apartia.fr>
Subject: Re: raid1 w/ 3 active mirrors?
Date: Mon, 30 May 2005 07:31:28 +0200
Message-ID: <429AA530.2040702@apartia.fr>
References: <429A13BC.2090809@bitzi.com> <429A1DF8.6050409@tls.msk.ru> <429A2E11.2070002@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429A2E11.2070002@bitzi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Mohr (@ Bitzi) a =E9crit :

> Michael Tokarev wrote:
>
>> Gordon Mohr (@ Bitzi) wrote:
>>
>>> I may have missed this is various docs, but is there any way to mak=
e
>>> a raid1 array which has 3 (or more) active mirrors, rather than 2=20
>>> mirrors
>>> and spares?
>>
>>
>>
>> On our machines with software raid, I usually use all available disk=
s to
>> create (small) root filesystem on raid1 - which is 2, 3, 4, 5, or ev=
en 8
>> on one machine.  There's no special restriction on number of mirrors=
 in
>> a raid1 set.  You create raid1 array on top of N disks exactly the s=
ame
>> as you create it on 2 disks.
>
>
> How do you make all the disks active mirrors? When I add a third=20
> partition
> to an functioning RAID1 array (mdadm -a), it always enters as a=20
> 'spare'. Only
> after another disk fails out will it be brought into sync with the=20
> remaining
> active partition.
>
> (I'd like the third partition to be brought into sync, and kept in sy=
nc,
> with the other two immediately, so that a fail does not trigger any
> flurry of activity.)
>
> Thanks,
>
> - Gordon @ Bitzi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

when you create the array:

mdadm -Cv /dev/md0 -l1 -n10 /dev/sd{a,b,c,d,e,f,g,h,i,j}1

--=20
La morale c'est l'ensemble des r=E8gles que l'on trouve excellentes pou=
r
autrui et inutile pour soi.
	-+- Voltaire -+-

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
