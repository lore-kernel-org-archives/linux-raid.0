From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: Expanding RAID array?
Date: Tue, 17 Jan 2006 00:30:37 +0100
Message-ID: <024201c61af4$dec2ab40$a400a8c0@dcccs>
References: <1137424449.3953.38.camel@kenny> <17356.8228.325002.652805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rowe@excc.ex.ac.uk
List-Id: linux-raid.ids

Hi,

----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "John Rowe" <rowe@excc.ex.ac.uk>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, January 16, 2006 11:37 PM
Subject: Re: Expanding RAID array?


> On Monday January 16, rowe@excc.ex.ac.uk wrote:
> > I have a 5-disk RAID5 array. Is it possible to add disks to increase the
> > array size and/or convert it to RAID6? (Indeed, what is the status of
> > RAID6?)
>
> - add disks to increase size of raid5
>     Possible offline with raidreconfig
>     Possible online with alpha-quality patches that I am
>       working on today. Will publish for experimentation/testing
>       later this week.  Hopefully stable by late Feb.

This patch will can do also chunksize conversion? :-)
And / or converting from N disk to N disk with different chunksize?

I think i will test it if i can get a copy. :-)

Cheers,
Janos

