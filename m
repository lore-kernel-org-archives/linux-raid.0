From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: [SOLVED] Re: Raid1 where Event Count off my 1 cannot assemble
 --force
Date: Mon, 09 Dec 2013 15:28:54 -0600
Message-ID: <52A63616.10909@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <20131209120040.6464b91b@notabene.brown> <52A546DB.3090605@suddenlinkmail.com> <20131209154639.3b9f801c@notabene.brown> <52A5531B.6080702@suddenlinkmail.com> <20131209164005.0e9ea273@notabene.brown> <alpine.DEB.2.02.1312090839360.24602@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1312090839360.24602@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/09/2013 01:40 AM, Mikael Abrahamsson wrote:
>> But yes, it doesn't hurt to add it to a wiki page somewhere.
> 
> I added this text to the wiki:
> 
> "There are bugs in older versions of mdadm, and a lot of "stable" operating
> system releases ship with really old mdadm versions. Recent versions are 3.2.x
> and 3.3.x. It's advisable if you run into problems assembling your raid to
> upgrade to the latest git version of mdadm. If you can get the raid to
> successfully assemble and recover with the git version, then it's fine to use
> your old mdadm version again for normal system operation. Newer mdadm doesn't
> make any changes to the array that isn't backwards compatible."

That ought to help the dummies out...

  As follow-up and confirmation of the help statement. I can confirm that after
repairing my arrays under mdadm 3.3.2, I was able to reboot and have the arrays
assemble and run with mdadm 2.6.4 without any issue. (good thing since the
problem was on the / partitions...)

  Now I just have to back-port mdadm-master to build and run on openSuSE 11.0
when the closest thing I can find is an 11.1 src.rpm. (should be close enough)

  Thank you again Neil and Mikael for all the help.

-- 
David C. Rankin, J.D.,P.E.
