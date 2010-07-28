From: Marco <jjletho67-diar@yahoo.it>
Subject: Re: raid1 performance
Date: Wed, 28 Jul 2010 12:10:28 +0000 (GMT)
Message-ID: <154057.96452.qm@web28515.mail.ukl.yahoo.com>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu> <23123.42111.qm@web28503.mail.ukl.yahoo.com> <20100726210324.6a4077e6@notabene> <379853.84515.qm@web28502.mail.ukl.yahoo.com> <20100728082358.4abc6868@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100728082358.4abc6868@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> No, the first field is the major device number, and the third is the device
> name ....
> so I guess we are taking the same ratio, but you start counting at a
> different place to me.

yes you are right, i started counting after the device name :-) Sorry for the 
confusion

> No.  It might be worth exploring why the request sizes are different - I
> don't know if it will lead anywhere useful though.

Have someone else    ever had a similar issue ?
In the meanwhile i will do some more test, trying to play with blockdevice 
related parameters...
Do you think that having the root partition mounted over /dev/md2 can influence 
the test results ? 


Marco


      
