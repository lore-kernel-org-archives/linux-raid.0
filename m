From: Jim Paris <jim@jtan.com>
Subject: Re: libata badness
Date: Mon, 4 Oct 2004 13:50:03 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20041004175003.GA10814@jim.sh>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu> <41617AA0.9020809@pobox.com> <Pine.LNX.4.60-041.0410041323160.9105@unix43.andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60-041.0410041323160.9105@unix43.andrew.cmu.edu>
To: William Knop <wknop@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

> I just got another oops while trying to cp from my md/raid5 array (2 of 3 
> sata drives) to another sata drive on the same controller. This time, 
> though, it said there's a bug in timer.c, line 405, and that the 
> stack's garbage. I'm thinking it has nothing to do with timer.c, and 
> something in md or libata is chomping all over the kernel.

Or else something else on your system is bad.  Like your CPU or RAM.
Run memtest for a while.

-jim
