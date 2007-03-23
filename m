From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Swap initialised as an md?
Date: Fri, 23 Mar 2007 23:35:10 +0300
Message-ID: <460439FE.8070605@tls.msk.ru>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net> <460436F1.2080003@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <460436F1.2080003@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David <lists@edeca.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
[]
> If you use RAID0 on an array it will be faster (usually) than just
> partitions, but any process with swapped pages will crash if you lose
> either drive. With RAID1 operation will be more reliable but no faster.
> If you use RAID10 the array will be faster and more reliable, but most
> recovery CDs don't know about RAID10 swap. Any reliable swap will also
> have the array size smaller than the sum of the partitions (you knew that).

You seems to forgot to mention 2 more things:

 o swap isn't usually needed for recovery CDs

 o kernel vm subsystem already can do equivalent of raid0 for swap internally,
   by means of allocating several block devices for swap space with the
   same priority.

If reliability (of swapped processes) is important, one can create several
RAID1 arrays and "raid0 them" using regular vm techniques.  The result will
be RAID10 for swap.

/mjt
