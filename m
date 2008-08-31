From: "Eric S. Johansson" <esj@harvee.org>
Subject: Re: I/O wait problem with hardware raid
Date: Sun, 31 Aug 2008 10:50:24 -0400
Message-ID: <48BAAFB0.8060103@harvee.org>
References: <48B75097.7000509@harvee.org> <48B995B9.2040600@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48B995B9.2040600@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> iowait means that there is a program waiting for I/O. That's all.=20

I was under the impression that I/O wait created a blocking condition.

> Of
> course when you do a copy (regardless of software) the CPU is waiting
> for disk transfers. I'm not sure what you think you should debug, i/o
> takes time, and if the program is blocked until the next input comes =
in
> it will enter the waitio state. If there is no other process to use t=
he
> available CPU it becomes waitio, which is essentially available CPU
> cycles similar to idle.
>=20
> What exactly do you think is wrong?

As I run rsync which increases the I/O wait state, the first thing I no=
tice is
that IMAP starts getting slow, users start experiencing failures in sen=
ding
e-mail, and the initial exchange for ssh gets significantly longer.

All of these problems have both networking and file I/O in common and I=
'm trying
to separate out where the problem is coming from.  I have run netcat wh=
ich has
shown that the network throughput is not wonderful but that's a differe=
nt
problem for me to solve.  When I run netcat, there is no degradation of=
 ssh,
IMAP or SMTP response times. the problem shows up if I run CP or rsync =
internal
source and target.   the problem becomes the worst when I'm doing rsync=
 within
the local filesystem and another rsync to an external rsync server.  At=
 that
point, the system becomes very close to unusable.

Of course, I can throttle back rsync and regain some usability but I'm =
backing
up a couple terabytes of information and it's a time-consuming process =
even with
rsync and would like  it to run as quickly as possible. I should probab=
ly point
out that the disk array is a relatively small raid five set up with six=
 1 TB
drives.  Never did like raid five especially when it's on a bit of firm=
ware.
Can't wait for ZFS (or its equivalent) on linux to reach production qua=
lity.

from where I stand right now, this might be "it sucks but it's perfectl=
y
normal".  In a situation with heavy disk I/O, I would expect anything t=
hat
accesses the disc to run slowly and in a more na=EFve moment, I thought=
 that the
GUI wouldn't be hurt by heavy disk I/O and then I remembered that gnome=
 and its
kindred have lots of configuration files to read every time you move th=
e mouse.  :-)

Any case, the people that sign my check aren't happy because they spent=
 all his
money on an HP server and performs no better than an ordinary PC.  I'm =
hoping I
can learn enough to give them a cogent explanation if I can't give them=
 a solution.


I appreciate the help.


---eric
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
