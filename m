From: Sandro Dentella <sandro.dentella@tin.it>
Subject: SRCS14L Controller?
Date: Wed, 14 Apr 2004 22:50:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040414205058.GA11159@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A customer of mine asked me to set up a fileserver on raid system. The
hardware they bought is an Intel RAID SRCS14L (a "hardware-based Serial ATA
(sata) RAID card"). Linux see it via gdth module.

My (and their) idea was to use sw RAID. Beside general discussion on which
is best (sw as opposed to hw), that I already followed on this list, I'd
like to know if there is any particular comment on this card that I
personally never used. I never used any SATA hard disks, really.

I only worked on that machine running on a live CD that I use to install
from remote, but what strickes me is that after loading the gdth module I
couldn't see any disks, even thought the module loaded correctly: using
devfs 'find /dev -name disc' gave no results. Any clues?

Thank in advance
sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
