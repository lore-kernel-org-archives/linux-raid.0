From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: draft howto on making raids for surviving a disk crash
Date: Mon, 04 Feb 2008 13:22:32 -0500
Message-ID: <47A757E8.1020105@tmr.com>
References: <20080202194131.GA7875@rap.rap.dk> <47A5E38F.6050603@tmr.com> <20080203170303.GB22179@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080203170303.GB22179@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Sun, Feb 03, 2008 at 10:53:51AM -0500, Bill Davidsen wrote:
>  =20
>> Keld J=F8rn Simonsen wrote:
>>    =20
>>> This is intended for the linux raid howto. Please give comments.
>>> It is not fully ready /keld
>>>
>>> Howto prepare for a failing disk
>>>
>>> 6. /etc/mdadm.conf
>>>
>>> Something here on /etc/mdadm.conf. What would be safe, allowing
>>> a system to boot even if a disk has crashed?
>>> =20
>>>      =20
>> Recommend PARTITIONS by used
>>    =20
>
> Thanks Bill for your suggestions, which I have incorporated in the te=
xt.
>
> However, I do not understand what to do with the remark above.
> Please explain.
>  =20

The mdadm.conf file should contain the "DEVICE partitions" statement to=
=20
identify all possible partitions regardless of name changes. See "man=20
mdadm.conf" for more discussion. This protects against udev doing=20
something innovative in device naming.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
