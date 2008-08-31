From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: I/O wait problem with hardware raid
Date: Sun, 31 Aug 2008 10:48:00 -0500
Message-ID: <48BABD30.2060607@gmail.com>
References: <48B75097.7000509@harvee.org> <48B995B9.2040600@tmr.com> <48BAAFB0.8060103@harvee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48BAAFB0.8060103@harvee.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric S. Johansson" <esj@harvee.org>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric S. Johansson wrote:
> Bill Davidsen wrote:
>=20
>> iowait means that there is a program waiting for I/O. That's all.=20
>=20
> I was under the impression that I/O wait created a blocking condition=
=2E
>=20
>> Of
>> course when you do a copy (regardless of software) the CPU is waitin=
g
>> for disk transfers. I'm not sure what you think you should debug, i/=
o
>> takes time, and if the program is blocked until the next input comes=
 in
>> it will enter the waitio state. If there is no other process to use =
the
>> available CPU it becomes waitio, which is essentially available CPU
>> cycles similar to idle.
>>
>> What exactly do you think is wrong?
>=20
> As I run rsync which increases the I/O wait state, the first thing I =
notice is
> that IMAP starts getting slow, users start experiencing failures in s=
ending
> e-mail, and the initial exchange for ssh gets significantly longer.
>=20
> All of these problems have both networking and file I/O in common and=
 I'm trying
> to separate out where the problem is coming from.  I have run netcat =
which has
> shown that the network throughput is not wonderful but that's a diffe=
rent
> problem for me to solve.  When I run netcat, there is no degradation =
of ssh,
> IMAP or SMTP response times. the problem shows up if I run CP or rsyn=
c internal
> source and target.   the problem becomes the worst when I'm doing rsy=
nc within
> the local filesystem and another rsync to an external rsync server.  =
At that
> point, the system becomes very close to unusable.
>=20
> Of course, I can throttle back rsync and regain some usability but I'=
m backing
> up a couple terabytes of information and it's a time-consuming proces=
s even with
> rsync and would like  it to run as quickly as possible. I should prob=
ably point
> out that the disk array is a relatively small raid five set up with s=
ix 1 TB
> drives.  Never did like raid five especially when it's on a bit of fi=
rmware.
> Can't wait for ZFS (or its equivalent) on linux to reach production q=
uality.
>=20
> from where I stand right now, this might be "it sucks but it's perfec=
tly
> normal".  In a situation with heavy disk I/O, I would expect anything=
 that
> accesses the disc to run slowly and in a more na=EFve moment, I thoug=
ht that the
> GUI wouldn't be hurt by heavy disk I/O and then I remembered that gno=
me and its
> kindred have lots of configuration files to read every time you move =
the mouse.  :-)
>=20
> Any case, the people that sign my check aren't happy because they spe=
nt all his
> money on an HP server and performs no better than an ordinary PC.  I'=
m hoping I
> can learn enough to give them a cogent explanation if I can't give th=
em a solution.
>=20
>=20
> I appreciate the help.
>=20


IO wait really means.

You are asking the IO subsystem to do more than it can, and one can do =
this *NO*=20
matter how fast ones disks are, in this case throttle the IO processes =
somewhat=20
to allow other things to still function.

The only real way out of this is to either throttle things, or get fast=
er disks=20
and/or raid subsystem.

I would suggest that you (with the machine otherwise unused) test seque=
ntial=20
reads and writes off the raid unit and post the speeds of those test, y=
ou will=20
need to make sure things break the cache to get real numbers, and also =
post the=20
number and type of disks that you have, that will give some idea of wha=
t the IO=20
system can do/should be able to do.

If the parts are picked incorrectly things will suck, there are several=
=20
different general classes of raid controller and some of them run alot =
faster=20
than the others (and cost more).   There are at least 3 classes of disk=
s (SATA,=20
SAS-10k, SAS-15k) and the more expensive ones run much faster.

Even the best of disks/raid controllers will run at full speed on any o=
f the=20
dual socket machines (from anyone) that has enough PCI-X and/or PCI-e b=
usses to=20
keep the contollers supplied with data.

How much one can push is related to how many PCI-X and/or PCI-e busses =
and how=20
much is shared between the different busses.   On most desktop boards *=
ALL* of=20
the pci busses are shared (there is only 132MB/second between all PCI s=
lots),=20
this got better with PCI-e but usually on desktop boards there aren't v=
ery many=20
of them.    On the higher end boards (usually 2+ socket, but some singl=
e socket=20
enterprise boards that have PCI-X) often there are several different PC=
I-X=20
busses that are not shared, and won't interfere with each other.   And =
on some=20
higher end AMD boards there are slots/chipsets connected to *BOTH* cpus=
, so that=20
increases possible bandwidth if done correctly.

                                 Roger
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
