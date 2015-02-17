From: Chris <email.bug@arcor.de>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Tue, 17 Feb 2015 10:37:28 +0000 (UTC)
Message-ID: <loom.20150217T112210-919@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown> <loom.20150217T080345-764@post.gmane.org> <alpine.DEB.2.02.1502170940010.4007@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike <at> swm.pp.se> writes:

> if I was running raid0 or linear, I might not want scterc to be 
> enabled.

Good Point.

> Also, what would the harm be to always bump the timeout to 180 seconds?

I don't know why the driver authors chose that linux default,
but the todo with both your points:


if the appearind device is an md member device (mdadm examine?)

  if smartctl tool is available
    if scterc is disabled in cotaining ${HDD_DEV} AND added device is not
raid0/linear
      /usr/sbin/smartctl -l scterc,70,70 ${HDD_DEV}

  echo 180 >/sys/block/${HDD_DEV}/device/timeout



 



