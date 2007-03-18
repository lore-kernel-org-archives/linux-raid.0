From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie
     who has read the FAQ)
Date: Sat, 17 Mar 2007 22:12:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Schwarz <mschwarz@multitool.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Sat, 17 Mar 2007, Michael Schwarz wrote:

> Nasty big stack trace set follows:

This format is kind of awkward.  For one thing, a lot of lines were 
wrapped by your email program.

For another, you copied the stack trace from the syslog log file.  That is 
not a good way to do it; syslogd is liable to miss bits and pieces of 
the kernel log when a lot of information comes along all at once.  You're 
much better off getting the stack trace data directly from dmesg.  (And 
when you do, you don't end up with 30 columns of wasted data added to the 
beginning of each line.)

Alan Stern

