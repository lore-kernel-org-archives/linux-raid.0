From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm problems with partitioned md devices
Date: Wed, 24 Nov 2004 10:17:57 +1100
Message-ID: <16803.50469.836305.127571@cse.unsw.edu.au>
References: <41A39846.9070002@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carl-Daniel Hailfinger on Tuesday November 23
Sender: linux-raid-owner@vger.kernel.org
To: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday November 23, c-d.hailfinger.kernel.2004@gmx.net wrote:
> Hi,
> 
> [please CC: me]
> while trying to use md to overcome limitations of dm, I
> stumbled upon the following problem: It is impossible to
> have more than 4 partitioned md devices since mdadm will
> create the 5th device with major:minor 255:0, which is
> bogus.

You need user-space (libc in particular) that supports the new 32bit
device numbers in 2.6.  I don't know which version of glibc that would
be, or which distributions support it.  debian/unstable (which I use)
doesn't support it yet :-(

You could test your distribution with
   mknod /tmp/test b 253 1024
   ls -l /tmp/test
   rm /tmp/test

and see if the major/minor is reported as "253, 1024" or "253, 0".
If the later, you need new glibc.
If the former, your userspace is up-to-date but there must be a bug in
mdadm.
If this is the case, let me know and I will look into it.

NeilBrown
