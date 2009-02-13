From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Fri, 13 Feb 2009 11:56:06 -0500
Message-ID: <4995A626.6030902@tmr.com>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4993E82D.1020309@fairbairn-family.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve Fairbairn wrote:
> Keld J=F8rn Simonsen wrote:
>>
>> I would rather have functionality to convert raid10 to raid5.
>> raid1 should be depreciated, as raid10,n2 for all purposes is the sa=
me
>> but better implementation and performance, and raid10,f2 and raid10,=
o2
>> are even better.  Nobody should use raid1 anymore.
>>
> Complete ignorance of raid10 here, but is raid10,<anything> bootable,=
=20
> like raid1 is?  I use raid1 on my root and boot partitions.

Note: if you use an initrd you can get away with raid1 on only the boot=
=20
partition (I do with Fedora/GRUB). And most "recovery CDs" will not use=
=20
a raid10 swap without starting it by hand, important only on small=20
memory machines.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
