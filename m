From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Good news / bad news - The joys of RAID
Date: Fri, 19 Nov 2004 21:58:21 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411192142360.19380@lion.drogon.net>
References: <419E6060.8030000@robinbowes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419E6060.8030000@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Nov 2004, Robin Bowes wrote:

> What actually happened was that I rebooted to activate a new kernel and
> the box didn't come back up. As the machine runs headless, I had to
> power it off and take it to a monitor/keyboard to check it.

Not directly related to your RAID issue, but I've been running headless
servers with console on serial ports as of late. LILO has an option to put
output on a serial line, and there's a kernel compile flag and an append
instruction to make it all work.

That combined with a power cycler makes me feel more at ease about the
remote servers I run.

Just don't connect 2 PCs back to back and run a getty on each serial
line...

Gordon
