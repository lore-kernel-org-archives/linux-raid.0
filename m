From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID1 problems
Date: Fri, 21 Feb 2003 11:11:06 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15957.28314.314427.191061@notabene.cse.unsw.edu.au>
References: <1045747209.795.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jean-Rene Cormier on  February 20
To: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  February 20, jean-rene.cormier@cipanb.ca wrote:
> Well since I had some trouble with raidtools giving me a Segfault when I
> tried to create an array, I decided to try mdadm, I can create an array
> and format it and mount it afterwards but after I unmount it I can't
> mount it again. I get an error saying unknown FS type or something like
> that. When I do an mdadm --detail /dev/md0 in the state it says dirty,
> no-error, shouldn't that be clean, no-error? How can I get that array to
> that state? I tried recreating that array like 5 times already and still
> the same thing. btw I'm running Linux 2.4.20 with glibc-2.3.1 if that
> changes anything.

It is always dirty when assembled and writable.  This is normal.

If you switch to read-only, it should should clean.
If you stop the array and use --examine on the devices, they should
show clean.

I cannot explain the mounting problem.  Maybe if you give more
specifics....

NeilBrown
