From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Superblock checksum problems
Date: Wed, 6 Sep 2006 09:07:38 +0200
Message-ID: <edls3q$jo4$1@sea.gmane.org>
References: <1157236610.8070.7.camel@localhost> <17659.46517.979409.131348@cse.unsw.edu.au> <1157385612.2990.4.camel@localhost> <1157403347.2990.11.camel@localhost> <1157404398.2990.14.camel@localhost> <17660.39978.663609.990424@cse.unsw.edu.au> <1157406418.2990.20.camel@localhost> <1157411506.6946.1.camel@localhost> <44FCBA2C.5070108@idgmail.se>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Henrik Holst <henrik.holst@idgmail.se> wrote:
> It would be good to have an analog to "memtest" but for PATA and SATA
> ports. Anyone seen something like that out there on the web?

Are you looking for `badblocks'?

There is also a `memtest.sh' from Doug Ledford. It's main intention is,
as the name suggests, to find memory problems. However, it does also
stress the disk a lot. In fact, it finds problems that occur somewhere
on the path from a disk to a CPU. If you increase its $NR_SIMULTANEOUS
to fill up your disk entirely, it should nearly do what you are looking
for (except for some blocks that are never touched because of filesystem
organization) :)


regards
   Mario
-- 
I thought the only thing the internet was good for was porn.  -- Futurama

