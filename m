From: "Mike Black" <mblack@csi-inc.com>
Subject: Re: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 09:17:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02e301c22814$27779300$f6de11cc@black>
References: <Pine.LNX.4.30.0207101505480.25329-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Danilo Godec <danci@agenda.si>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You don't say why two disks were kicked or when it happend so sdc may be out-of-whack a bit.  Sounds like sdc got kicked first.
So...I would do a bad-block scan on sdb2 so it can remap the bad section and re-build as you've been trying to do.

If you REALLY want to use sda and sdc just rebuild the array with --create and leave sdb out of it.  You shouldn't lose much data if
sdc is current.
----- Original Message -----
From: "Danilo Godec" <danci@agenda.si>
To: <linux-raid@vger.kernel.org>
Sent: Wednesday, July 10, 2002 9:10 AM
Subject: Multiple disk failure - recover?


> Hi!
>
> I have (had) a three disk RAID5 array. One of the disks (sdb2) has failed,
> however, under circumstances, two of the diskes were kicked out of the
> array.
>
> I tried re-assembling the array using 'mdadm --assemble --force /dev/md1
> /dev/sda2 /dev/sdc2 /dev/sdb2', but it always takes the sdc2 & sdb2 as OK
> disks and sda2 as failed.
>
> Of course, when the reconstruction hits the bad area on sdb2, it all fails
> again.
>
> How can I tell mdadm that /dev/sda2 and /dev/sdc2 are the disks I want as
> 'good'!?
>
> Thanks, D.
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

