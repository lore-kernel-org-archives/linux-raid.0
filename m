From: Aaron Greenspan <aarong@thinkcomputer.com>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Sun, 30 Sep 2012 21:55:27 -0700
Message-ID: <8C2056A6-5E2E-4E02-AF9A-1C07158776CB@thinkcomputer.com>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com> <20121001125510.6cc0c2be@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001125510.6cc0c2be@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

The kernel I'm using is...

[root@kermit plainsite]# uname -a
Linux kermit.thinkcomputer.com 2.6.32-71.el6.i686 #1 SMP Fri Nov 12 04:17:17 GMT 2010 i686 i686 i386 GNU/Linux

However, I have downloaded an update that I can install and hopefully that will fix the issue.

One other question: why do df, /proc/mdstat, and other utilities always list the RAID arrays in random order? I'm always expecting md0 to show up first, followed by md1, md2, etc. but this is rarely actually the way that the arrays are ordered. It makes it kind of confusing when different utilities do things differently.

Thanks for your help,

Aaron
	
Aaron Greenspan
President & CEO
Think Computer Corporation

telephone +1 415 670 9350
toll free +1 888 815 8599
fax +1 415 373 3959
e-mail aarong@thinkcomputer.com
web http://www.thinkcomputer.com
