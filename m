From: Steven Dake <sdake@mvista.com>
Subject: raid1 critical sections not protected in 2.4.x?
Date: Thu, 09 Oct 2003 10:41:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1065721318.4761.138.camel@persist.az.mvista.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I have been looking at the raid1.c code.  There is a kernel thread
raid1d that could be scheduled on processor A.  Then on processor B,
other raid code could be scheduled as per each block I/O request.

The particular critical section is the usage of the conf variable, and
specifically conf->mirrors.  raid1d reads conf->mirrors[x] while other
parts of the md code alter it simulatenously.

Is this a bug?  It might explain how people see counts get out of wack
on the media...

Thanks
-steve


