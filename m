From: Chris <email.bug@arcor.de>
Subject: help with the little script (erc timout fix)
Date: Wed, 18 Feb 2015 15:04:53 +0000 (UTC)
Message-ID: <loom.20150218T155053-576@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

by adapting what I could find, I compiled the following short snippet now.

Could list members please look at this novice code and suggest a way to 
determine the containing disk device $HDD_DEV from the parition/disk,
before I dare to test this.



In udev-md-raid-assembly.rules, below LABEL="md_inc" (section only handling
all md suppported devices) add:

# fix timouts for redundant raids, if possible
IMPORT{program}="BINDIR/mdadm --examine --export $tempnode"
TEST="/usr/sbin/smartctl", ENV{MD_LEVEL}=="raid[1-9]*",
RUN+="BINDIR/mdadm-erc-timout-fix.sh $tempnode"

And in a new mdadm-erc-timout-fix.sh file implement:

  #! /bin/sh

  HDD_DEV= $1 somehow stipping off the tailing numbers?

  if smartctl -l scterc ${HDD_DEV} | grep -q Disabled ; then
    /usr/sbin/smartctl -l scterc,70,70 ${HDD_DEV}
  else
    if ! smartctl -l scterc ${HDD_DEV} | grep -q seconds ; then
      echo 180 >/sys/block/${HDD_DEV}/device/timeout
    fi
  fi

Correct execution during boot would seem to require that distro
package managers hook smartctl and the script into the initramfs
generation.

Regards,
Chris

