From: David Greaves <david@dgreaves.com>
Subject: Re: nested raid possible?
Date: Fri, 06 Jul 2007 08:57:37 +0100
Message-ID: <468DF5F1.8010004@dgreaves.com>
References: <8585506.1183693119573.JavaMail.root@wombat.diezmil.com> <468DD806.6070608@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468DD806.6070608@ieee.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: turbo@weasel.com
List-Id: linux-raid.ids

Simon Valiquette wrote:
> turbo@weasel.com un jour =C3=A9crivit:
>> I have a raid-5 array of six 250gb hard drives.
>> I just bought four 500gb hard drives.

Simon raised some sensible points.

Also consider a raid5 of the 4x500 drives and using LVM to join them to=
 a raid 5=20
of the 6x250s

The benefit using raid0 to join the 250s may be that you can replace ea=
ch of the=20
2x250 with 1x500 as time passes. In that case you may want a raid6 made=
 of :
  500 500 500 500 250+250 250+250 250+250

One thing I'd ceertainly suggest is creating partitions of 498Gb to all=
ow for=20
geometry variations....

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
