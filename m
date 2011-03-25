From: hank peng <pengxihan@gmail.com>
Subject: Re: why disk errors are more likely to happen on md super block area?
Date: Fri, 25 Mar 2011 10:27:23 +0800
Message-ID: <AANLkTikvUY1n5UYqTnK-djJvy0a_nmcTg0B8MPEfEw5T@mail.gmail.com>
References: <AANLkTik2W3e7BaHdJ1UPxhQWHXm00NAiesUP0AejV6gp@mail.gmail.com>
	<AANLkTi=2QK7k=exbdPgshQgBYP3tnO76gyXGqW5TCsUN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2QK7k=exbdPgshQgBYP3tnO76gyXGqW5TCsUN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/3/24 Roberto Spadim <roberto@spadim.com.br>:
> i think you will have no problems with location of metadata, there's
> some versions of metadata, at start at end.. check your mdadm --creat=
e
> command

yes, I found that option. If I choose to put metadata on the start
area of a disk, disk's head seek time will be decreased, right?

So, is there someone in this list to tell me what is real difference
when putting meta data on start or end of a disk?

> what information at metadata is/was wrong? can you get it? or just i/=
o error?
> some months ago i had two broken harddisks, the disk start to read
> from position 0 to position X without problem, but when it get at a
> position where disk was crashed (real crashed, the disk hit the floor=
)
> the array start to resync (maybe a disk report) it was a raid10 array=
=2E
> maybe you have problem at physical layer (disk with problem).
> i don't know what informations md update at metadata, but i think tha=
t
> there's some last write counter/last write timestamp to sync what
> mirrors is more recent in a broken array start, (this information can
> be found with others developers in this list)
>
> 2011/3/23 hank peng <pengxihan@gmail.com>:
>> Hi, guys:
>> I found that when disk errors happened, it is more likely to locate =
in
>> md super block area. Kernel messages are like this:
>> end_request: I/O error, dev sda, sector 1953525000
>> md: super_written gets error=3D-5, uptodate=3D0
>> In some cases, I check if disk is really failed using 'dd' command a=
nd
>> found that it is OK for read and write on those sectors.
>>
>> I know that md super block information is located in the end of a
>> disk, but is it related with this problem? Is it safer to put md sup=
er
>> block in the start area of a disk?
>>
>>
>> --
>> The simplest is not all best but the best is surely the simplest!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
