From: Larry Schwerzler <larry@schwerzler.com>
Subject: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 12:55:05 -0800
Message-ID: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a few questions about my raid array that I haven't been able to
find=A0definitive=A0answers for, so thought I would ask here.
My setup:

* 8x 1TB drives in an external enclosure connected to my server via 2
esata cables.
* Currently all 8 drives are included in a raid 6 array.
* I use the array to serve files (mostly larger .mkv/iso (several GB)
and .flac/.mp3 (5-50MB) files) over my network via NFS and to perform
offsite backup via rsync over ssh of another server.
* This is a system in my home, so prolonged downtime, while annoying,
is not the end of the world.
* If it matters Ubuntu 10.04 64bit server is my distro

I'm considering and likely going to move forward moving my data and
rebuilding the array as a raid10 array. Just a few questions before I
make the switch.

Questions:

1. In my research of raid10 I very seldom hear of drive configurations
with more drives then 4, are there special considerations with having
an 8 drive raid10 array? I understand that I'll be loosing 2TB of
space from my current setup, but i'm not too worried about that.

2. One problem I'm having with my current setup is the esata cables
have been knocked loose which effectively drops 4 of my drives. I'd
really like to be able to survive this type of sudden drive loss. if
my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
while efgh are on the other is there what drive order should I create
the array with? I'd guess /dev/sd[aebfcgdh] would that give me
survivability if one of my esata channels went dark?

3. One of the concerns I have with raid10 is expandability, and I'm
glad to see reshaping raid10 as an item on the 2011 roadmap :) However
it will likely be a while before I'll see that ability in my distro
for a while. I did find a guide on expanding raid size when using lvm
by increasing the size of each drive and creating two partitions 1 the
size of the original drive, and one with the remainder of the new
space. Once you have done this for all drives you create a new raid10
array with the 2nd partitions on all the drives and add it to the lvm
storage group, effectively you have two raid10 arrays 1 on the first
half of the drives 1 on the 2nd half of the drives and the space
pooled together. I'm sure many of you are familiar with this scenario,
but I'm wondering if this scenario could be problematic, is having two
raid10 arrays on one drive an issue?

4. Part of the reason I'm wanting to switch is because of information
I read on the "BAARF" site pointing out some of the issues in the
parity raid's that can cause issues that people sometimes don't think
about. (site:=A0http://www.miracleas.com/BAARF/BAARF2.html) A lot of th=
e
information on the site is a few years old now and given how fast
things can change and the fact that I have not found many people
complaining about the parity raids I'm wondering if some/all of the
gotchas that they list are less of an issue now? Maybe my reasons for
moving to raid10 are no longer relevant?

Thank you in advance for any/all information given. And a big thank
you to Neil and the other developers of linux-raid for=A0their=A0effort=
s
on this great tool.
Larry Schwerzler
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
