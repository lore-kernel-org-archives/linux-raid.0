From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: why disk errors are more likely to happen on md super block area?
Date: Thu, 24 Mar 2011 00:48:18 -0300
Message-ID: <AANLkTi=2QK7k=exbdPgshQgBYP3tnO76gyXGqW5TCsUN@mail.gmail.com>
References: <AANLkTik2W3e7BaHdJ1UPxhQWHXm00NAiesUP0AejV6gp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik2W3e7BaHdJ1UPxhQWHXm00NAiesUP0AejV6gp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think you will have no problems with location of metadata, there's
some versions of metadata, at start at end.. check your mdadm --create
command
what information at metadata is/was wrong? can you get it? or just i/o =
error?
some months ago i had two broken harddisks, the disk start to read
from position 0 to position X without problem, but when it get at a
position where disk was crashed (real crashed, the disk hit the floor)
the array start to resync (maybe a disk report) it was a raid10 array.
maybe you have problem at physical layer (disk with problem).
i don't know what informations md update at metadata, but i think that
there's some last write counter/last write timestamp to sync what
mirrors is more recent in a broken array start, (this information can
be found with others developers in this list)

2011/3/23 hank peng <pengxihan@gmail.com>:
> Hi, guys:
> I found that when disk errors happened, it is more likely to locate i=
n
> md super block area. Kernel messages are like this:
> end_request: I/O error, dev sda, sector 1953525000
> md: super_written gets error=3D-5, uptodate=3D0
> In some cases, I check if disk is really failed using 'dd' command an=
d
> found that it is OK for read and write on those sectors.
>
> I know that md super block information is located in the end of a
> disk, but is it related with this problem? Is it safer to put md supe=
r
> block in the start area of a disk?
>
>
> --
> The simplest is not all best but the best is surely the simplest!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
