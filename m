From: Steve Lane <drsteve@rna.berkeley.edu>
Subject: question about mdadm + grub interaction
Date: Mon, 5 Nov 2007 16:39:25 -0800
Message-ID: <20071106003925.GW5467@turing.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-user=gldu-debian-user-2=m.gmane.org@lists.debian.org>
Content-Disposition: inline
Resent-Message-ID: <gHP2Y.A.yVC.Tt7LHB@murphy>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
Cc: Steve Lane <drsteve@rna.berkeley.edu>
List-Id: linux-raid.ids

Greetings.  In order to insure that a Debian stock kernel (i.e. the
kernel installed from the linux-image-2.6.22-2-686-bigmem package) boots
correctly off of a mdadm RAID 1 set of two disks if one of the disks is
dead, do we:

1) Have to manually install grub on the MBR on *both* drives, or is this
   done automagically by the grub package installer if the RAID 1 set
   is in place at the time of the grub install?

2) Need to have something that looks like this in /boot/grub/menu.lst:

   A)
      title           Debian GNU/Linux, kernel 2.6.21-2-686-bigmem, RAID1
      root            (hd0,0)
      kernel          /vmlinuz-2.6.21-2-686-bigmem root=/dev/md2 md=0,/dev/sda1,/dev/sdb1 ro
      initrd          /initrd.img-2.6.21-2-686-bigmem
      savedefault

      title           Debian GNU/Linux, kernel 2.6.21-2-686-bigmem, BROKEN RAID1
      root            (hd0,0)
      kernel          /vmlinuz-2.6.21-2-686-bigmem root=/dev/md2 md=0,/dev/sdb1 ro
      initrd          /initrd.img-2.6.21-2-686-bigmem
      savedefault

   i.e. with the 'md=...' configuration options?  Or do we just need this:

   B)
      title           Debian GNU/Linux, kernel 2.6.21-2-686-bigmem
      root            (hd0,0)
      kernel          /vmlinuz-2.6.21-2-686-bigmem root=/dev/md2 ro
      initrd          /initrd.img-2.6.21-2-686-bigmem
      savedefault

   which is the sort of thing that is installed automagically by the
   kernel package installer?

3) Need to have the 'md=...' configuration option point at the *boot*
   partition, or the *root* partition, so that if we have:

      md0 : active raid1 sda1[0] sdb1[1]
      md2 : active raid1 sda3[0] sdb3[1]

   and

      /dev/md0   /boot
      /dev/md2   /

   do we then need:

      md=0,/dev/sda1,/dev/sdb1
      md=0,/dev/sdb1

   or:

      md=2,/dev/sda3,/dev/sdb3
      md=2,/dev/sdb3

Any pointers to *detailed* documentation about how the 'md=...' option
works would be much appreciated; I've already seen:

  http://www.debian-administration.org/articles/238

(which has a question at the very bottom of the page, a bit over two
months old, asking very similar sorts of questions -- no answer on the
page so far...); and

  http://alephnull.net/software/linux-raid/4%20-%20Setup.html

(which is lilo-specific, but also informative); and

  http://www.epimetrics.com/topics/one-page?page_id=449&topic=Bit-head%20Stuff&page_topic_id=120

AND:

  http://www.opensubscriber.com/message/linux-raid@vger.kernel.org/7889881.html

(which is informative, but doesn't get at precise answers to my questions).

Thanks much,

--
Steve Lane
System, Network and Security Administrator
Doudna Lab
Biomolecular Structure and Mechanism Group
UC Berkeley
