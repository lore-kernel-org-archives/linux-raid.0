From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: recovery from multiple failures
Date: Sun, 08 Jan 2012 20:51:06 -0800
Message-ID: <qa8qt8xi1r.ln2@goaway.wombat.san-francisco.ca.us>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
 <4F0A30CD.60904@turmel.org>
 <fatpt8x1so.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-01-09, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> md/raid:md0: cannot start dirty degraded array.

Upon further reading (specifically man md), it looks like this is the
tail reason for the array not starting--the kernel will refuse to start
arrays in this condition.  If I'm reading the docs and other posts
accurately, it seems like I can use a kernel parameter (since this isn't
my /, I should also be able to unload and re-load the md module) to
force the kernel to start the array, at which point in theory I should
be able to work with it (including, ultimately, an xfs_repair if
needed).  But OTOH, it seems like this parameter applies only to / on
mdraid, and --force should have started the array, so I'm not really
sure what to make of it.

I've posted this before, but the kernel I'm using is fairly recent,
2.6.39-4.el5 from ELrepo.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


