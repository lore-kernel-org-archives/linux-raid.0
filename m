From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: meta: should i chase this down?
Date: Tue, 06 Dec 2011 16:02:44 -0800
Message-ID: <42n2r8xe3k.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

A little while back, I had a strange issue, where reshaping a RAID6 to
add a disk, then performing significant write activity (in this case, an
rsnapshot), would cause a kernel crash.  I only attempted this twice,
and neglected to write down the kernel oops errors, but I saw a few
calls that seemed to imply that the md driver might be involved.  (Doing
the same write activity during a rebuild is fine, which is another
reason I suspected the reshape code in the md driver.  If it's of
interest, I'm using kernel 2.6.39-4.el5.elrepo from ELRepo on a CentOS
5.7 box.)  It's certainly possible that I have a hardware issue, but not
being able to reliably replicate the issue outside a reshape complicates
debugging.

My question is, should I try to hunt down the actual source of this
crash, and if so, what would be the best way to go about that?  I am
decidedly not a kernel developer, and am not familiar with how to obtain
debugging information in that environment.  I'm happy enough for this
machine to suffer crashes, but I prefer not to work with the existing
RAID6 if possible, and would want a more reliable way of collecting the
kernel's debug output beyond writing it down on paper.  :)

Thanks,

--keith

-- 
kkeller@wombat.san-francisco.ca.us


