From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: very slow file deletion on an SSD
Date: Fri, 25 May 2012 11:48:01 -0300
Message-ID: <CABYL=Toi+Mbm1nJ=5HhBnjYiK9ZEL-SYmwe3aLtm5CzTdR8zcg@mail.gmail.com>
References: <4FBF60D1.80104@gmail.com>
	<4FBF62D2.20702@fastmail.fm>
	<4FBF63B0.6020209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBF63B0.6020209@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

noop scheduler could be better for ssd?

2012/5/25 Joe Landman <joe.landman@gmail.com>:
> On 05/25/2012 06:45 AM, Bernd Schubert wrote:
>>
>> Hello Joe,
>>
>> On 05/25/2012 12:37 PM, Joe Landman wrote:
>>>
>>> Hi folks:
>>>
>>> Just ran into this (see posted output at bottom). 3.2.14 kernel, MD=
 RAID
>>> 5, xfs file system. Not sure (precisely) where the problem is, henc=
e
>>> posting to both lists.
>>
>>
>> do you have anything enabled, that would make your files to have xat=
trs?
>
>
> Not to my knowledge. =A0I'll go back and re-create some files and see=
=2E
>
>> http://oss.sgi.com/archives/xfs/2011-08/msg00233.html
>
>
> Hmmm
>
>
>
> --
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics Inc.
> email: landman@scalableinformatics.com
> web =A0: http://scalableinformatics.com
> =A0 =A0 =A0 http://scalableinformatics.com/sicluster
> phone: +1 734 786 8423 x121
> fax =A0: +1 866 888 3112
> cell : +1 734 612 4615
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
