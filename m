From: "Jonathan Vardy" <jonathanv@explainerdc.com>
Subject: Re: RAID 5 performance problems
Date: Sat, 5 Apr 2003 02:10:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <036201c2fb07$b41b8340$2e77c23e@pentium4>
References: <73300040777B0F44B8CE29C87A0782E101FA98FB@exchange.explainerdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

RE: RAID 5 performance problems> I've rebooted with the original Red Hat
kernel (2.4.20) and it
> recognizes the drives correctly now (UDMA100) but the performance is
> still poor

Good news; I've finally got the performance up to a good level. Bonnie++ now
gives 77MB/sec read and 25MB/sec write speeds.

The problem was being caused by a setting in the mainbaord BIOS; "PCI
latency timer" had a default value of 0, after changing this to 32 the drive
speed (hdparm) doubled and the raid finally performed as it should.

I'd like to thank everybody who responded for giving me advice on the
problem, I apreciate it greatly.

Yours sincerely, Jonathan Vardy
