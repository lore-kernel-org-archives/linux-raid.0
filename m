From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Raid1 and mdadm
Date: Tue, 01 Apr 2003 11:07:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E89B947.C3838E0E@SteelEye.com>
References: <A5974D8E5F98D511BB910002A50A66470580D71F@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Cress, Andrew R" wrote:

> However, you MUST link the md driver into the kernel.  It doesn't work right
> as a module, even in initrd.

BTW, it would be nice if this were fixed, so that md could be compiled
as a module...would the maintainers be willing to accept patches that
would make "autostart" a module option, so that upon insertion of the md
module it would do the autostart stuff, or something similar? From what
I can tell, we basically need to remove some ifndef MODULE stuff and
make the autostart option call autostart_arrays(), as it is when md is
linked into the kernel...

Or is there a better way to do this?

--
Paul
