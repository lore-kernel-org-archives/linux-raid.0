From: "Jeff Breidenbach" <breidenbach@gmail.com>
Subject: Re: Propose of enhancement of raid1 driver
Date: Thu, 19 Oct 2006 21:59:58 -0700
Message-ID: <e03b90ae0610192159o270a0cf3j94ccdd393d314cb6@mail.gmail.com>
References: <45347D6E.3000600@mieszczak.com.pl>
	 <17718.61672.794099.425723@cse.unsw.edu.au>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17718.61672.794099.425723@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Miroslaw Mieszczak <mirek@mieszczak.com.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The raid10 module in linux supports a layout described as 'far=2'.
> In this layout, with two drives, the first half of the drives is used
> for a raid0, and the second half is used for a mirrored raid0 with the
> data on the other disk. In this layout reads should certainly go at
> raid0 speeds, though there is cost in the speed of writes.

Remember, RAID-10 far=2 mode was very slow in July 2005; don't
know if it has improved since then. See:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg02339.html

PS. If you ever need it I have plenty of data from a super redundant
5 disk RAID-1 recorded with atsar.  It does quite well balancing
many small, parallel random reads from a webserver.  Struggles
a little when mixing a single large read with many small parallel
reads.
