From: Jim Paris <jim@jtan.com>
Subject: Re: Please help!  How to reconstitute array (drive order problem)?
Date: Wed, 27 Oct 2004 14:54:32 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041027185432.GA23904@jim.sh>
References: <m3vfcw3035.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m3vfcw3035.fsf@bfnet.com>
To: David Wuertele <dave-gnus@bfnet.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> These drives came up something like hda, hdi, hdh, hdk, hdm, hdn, hdp,
..
> drive.  These drives were hda, hdi, and hdk (I only know this because
..
> the drives' new names were hde, hdg, and hdo.

So your drives are now hde, hdg, hdo, hdh, hdm, hdn, hdp.  Something like
  mdadm --assemble /dev/md0 hd[egohmnp]
should do the trick.

--

BTW, speaking of mdadm, with no config file, the commands
  mdadm --assemble /dev/md0
  mdadm --assemble --scan /dev/md0
  mdadm --assemble --scan /dev/md0 /dev/hd[egohmnp]
all segfault.  They're probably not sensible commands to run, but it
should give an error in that case.

-jim
