From: Steven Rodenburg <steven.rodenburg@planet.nl>
Subject: LVM / EXT3 production ready ?
Date: 07 Apr 2002 15:22:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1018185738.5687.16.camel@adagio.adagio.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was wondering if the Logical Volume Manager (LVM) on for example SuSE
7.3 is any good in a proffesional "24 x 7 x Forever" "many GB/TB's SAN"
production enviroment.

In my/our company's case being able to logically expand hardware raid
sets and partitions in a real production enviroment is important. We
plan to use linux because Linux itself is stable and robust enough and a
good alternative to say SUN Solaris.

But downtime due to a problem with the Linux LVM is not an option.
Normally, we would add an array within the SAN and then create a new
(very big) filesystem on it and mount it. But when we could expand a
partition on the fly that would be better.

And can the LVM be used with RedHat 7.2 as well (i can't find it on the
distro) ?

How does EXT3 (we need journaling) behave on very large filesystems
(many GB/TB's) ?

I like EXT3 because loss of the journal do not pose big problems because
the partition can be mounted EXT2 and run until a time-window arrives to
repair the journal and mount it back again with EXT3.

It's all about MASSIVE fileserving.

In short:  are LVM and EXT3 mature/stable enough ?


Gr,
Steve


