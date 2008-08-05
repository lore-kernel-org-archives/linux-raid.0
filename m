From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Q: Is this how 'check' works (on raid10 in particular)?
Date: Mon, 4 Aug 2008 20:36:33 -0500
Message-ID: <cccedfc60808041836s37637ff2x3d65543ab7d3d105@mail.gmail.com>
References: <cccedfc60808030532u14cfd668vfeca77a79996d11@mail.gmail.com>
	 <20080803125413.GA10118@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080803125413.GA10118@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The patch Keld sent me makes a significant difference:

Before:
(Stock 2.6.25.11 x86-64 openSUSE 11.0 kernel raid10 module):   4.5h to 5.5h

After:
Same kernel, minor changes to raid10.c and compiled:  1h 56m.

::

Aug  4 18:37:09 turnip kernel: md: data-check of RAID array md0
Aug  4 20:33:24 turnip kernel: md: md0: data-check done.


> My idea is to do the checks in bigger blocks, then you would minimize
> the trashing, by minimizing the number of times you need to move the
> head.  And this would not need much change in the code. I have done a
> patch to do this, but I have not yet tested it.


-- 
Jon
