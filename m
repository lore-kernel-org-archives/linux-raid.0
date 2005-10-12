From: Tim Walberg <twalberg@mindspring.com>
Subject: Re: big fault :-)
Date: Wed, 12 Oct 2005 09:41:33 -0500
Message-ID: <20051012144133.GK2870@mindspring.com>
References: <434BE7CA.4040707@gmx.de> <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si> <434D18EF.6060507@onlinehome.de>
Reply-To: Tim Walberg <twalberg@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <434D18EF.6060507@onlinehome.de>
Sender: linux-raid-owner@vger.kernel.org
To: Karsten =?iso-8859-1?Q?R=F6mke?= <biermann-roemke@onlinehome.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In order to do that, the file system that lives on the RAID device
has to support being shrunk first, which is possible in some cases,
but far from all. Typically this would involve dumping the data
somewhere, shrinking the RAID, then re-creating a filesystem and
moving the data back...

				tw



On 10/12/2005 16:08 +0200, Karsten R=F6mke wrote:
>>	By the way: is it possible to make a raid1 array SMALLER?
>>	 I found hints howto get it bigger and the way seems very easy, but
>>	 to shrink it? Reason: When I set up the server I have some people b=
ehind
>>	 me, who mostly say: can't it be faster? - so I accepted the partion=
s which=20
>>	 are
>>	 recommended by Suse (and which are not really suitable for my needs=
)
>>=09
>>=09
>>	-
>>	To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
End of included message



--=20
+--------------------------+------------------------------+
| Tim Walberg              | twalberg@mindspring.com      |
| 830 Carriage Dr.         | www.mindspring.com/~twalberg |
| Algonquin, IL 60102      |                              |
+--------------------------+------------------------------+
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
