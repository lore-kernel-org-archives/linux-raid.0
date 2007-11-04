From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Sun, 04 Nov 2007 15:48:12 +0300
Message-ID: <472DBF8C.2060508@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
> 
> After several days/weeks, this is the second time this has happened,
> while doing regular file I/O (decompressing a file), everything on the
> device went into D-state.

The next time you come across something like that, do a SysRq-T dump and
post that.  It shows a stack trace of all processes - and in particular,
where exactly each task is stuck.

/mjt
