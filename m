From: Laurent CARON <lcaron@apartia.fr>
Subject: Re: RAID 5 of RAID 5's?
Date: Mon, 13 Jun 2005 09:15:39 +0200
Message-ID: <42AD329B.4080103@apartia.fr>
References: <1118187572.15459.96.camel@seki.nac.uci.edu>	 <42A93D30.6080900@apartia.fr> <1118436219.25226.252.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1118436219.25226.252.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Stromberg a =E9crit :

>On Fri, 2005-06-10 at 09:11 +0200, Laurent CARON wrote:
> =20
>
>>Dan Stromberg a =E9crit :
>>
>>   =20
>>
>>>Has anyone constructed a RAID 5 of RAID 5's using mdadm on a linux
>>>system?
>>>
>>>Was it reliable?
>>>
>>>How large was it?
>>>
>>>Thanks!
>>>
>>>=20
>>>
>>>     =20
>>>
>>Seems to be a large waste of space....
>>   =20
>>
>
>Consider:
>
>You have a bunch of "bricks" that can shuffle data between a NAS head
>and a bunch of disks.
>
>The disks are RAID'd (through the "bricks"), but if one of the bricks
>themselves dies, you're kinda stuck.
>
>But if you RAID 5 the RAID 5's, then you don't end up with massive
>parity pounding, and your bricks aren't a single point of failure, and
>you don't lose as much space as if you mirrored.
>
>Sound copacetic?
>
>Thanks for your feedback!
>
> =20
>
RAID 10 is IMHO a bit more efficient.

Raid 5 means at least 9 disks:
Usable capacity: 4 Disks
Read speed: Good
Write speed: poor

Raid 10 with 8 disks can store the same amount of data.
Read speed: Average
Write Speed: Better than raid5


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
