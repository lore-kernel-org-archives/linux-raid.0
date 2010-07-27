From: Neil Brown <nfbrown@novell.com>
Subject: Re: raid1 performance
Date: Wed, 28 Jul 2010 08:23:58 +1000
Message-ID: <20100728082358.4abc6868@notabene>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
	<20100725211926.7547c12e@natsu>
	<23123.42111.qm@web28503.mail.ukl.yahoo.com>
	<20100726210324.6a4077e6@notabene>
	<379853.84515.qm@web28502.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <379853.84515.qm@web28502.mail.ukl.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco <jjletho67-diar@yahoo.it>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Jul 2010 16:10:36 +0000 (GMT)
Marco <jjletho67-diar@yahoo.it> wrote:

> 
> 
> 
> 
> >If you look at /proc/diskstats and particularly the 4th and 6th fields for
> >the device that you are interested in, and then take the differences for each
> >field between 'before' and 'after' running a test you will get
> > - the number of IO requests
> >  - the number of sectors
> >
> >that were serviced during that time.  Taking a ratio will get you the number
> >of sectors per IO.  Normally more is better.
> 
> Hi Neil,
> are you sure the right value are the 4th and the 6th fields ? I see strange 
> value in them (the 4th field is bigger then the 6th while i was expecting the 
> contrary)
> looking in the iostats.txt file (kernel documentation) i suspect the fields you 
> are interested are the first and the third.

No, the first field is the major device number, and the third is the device
name ....
so I guess we are taking the same ratio, but you start counting at a
different place to me.

> In this hypothesis (1st and 3rd fields) the ratio i obtain are:
> 
> sda 84.02 
> sdb 113,69
> md2 8,01
> 
> md2 and his meber have a very different ratio....

Strange isn't it.  And the ratios are the other-way-around to what I get.
I don't currently understand why ... but it might not be at all relevant to
the speed difference.

> 
> >It might be interesting to find out what the data offset is for your RAID1
> >(mdadm --examine will tell you if there is one), and compare the
> > request/sector numbers and see if they show anything.
> 
> this is the output of mdadm --examine /dev/sda3
> 
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.90.00

OK, so there is no data offset with 0.90, so that rules out differing offsets
being an issue.

> 
> Do you have some hypothesis ?

No.  It might be worth exploring why the request sizes are different - I
don't know if it will lead anywhere useful though.

NeilBrown

> 
> thank you all
> 
> Marco
> 
> 
> 
>       

