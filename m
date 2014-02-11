From: Andrew Martin <amartin@xes-inc.com>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Tue, 11 Feb 2014 17:10:57 -0600 (CST)
Message-ID: <700319865.79921.1392160257000.JavaMail.zimbra@xes-inc.com>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com> <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com> <20140212065420.4643f9a1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140212065420.4643f9a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Andrew Martin" <amartin@xes-inc.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Tuesday, February 11, 2014 1:54:20 PM
> Subject: Re: Automatically drop caches after mdadm fails a drive out of an array?
> 
> On Tue, 11 Feb 2014 11:11:04 -0600 (CST) Andrew Martin <amartin@xes-inc.com>
> wrote:
> 
> > Hello,
> > 
> > I am running mdadm 3.2.5 on an Ubuntu 12.04 fileserver with a 10-drive
> > RAID6 array (10x1TB). Recently, /dev/sdb started failing:
> > Feb 10 13:49:29 myfileserver kernel: [17162220.838256] sas: command
> > 0xffff88010628f600, task 0xffff8800466241c0, timed out: BLK_EH_NOT_HANDLED
> > 
> > Around this same time, a few users attempted to access a directory on this
> > RAID array over CIFS, which they had previously accessed earlier in the
> > day. When they attempted to access it this time, the directory was empty.
> > The emptiness of the folder was confirmed via a local shell on the
> > fileserver, which reported the same information. At around 13:50, mdadm
> > dropped /dev/sdb from the RAID array:
> 
> The directory being empty can have nothing to do with the device failure.
> md/raid will never let bad data into the page cache in the manner you
> suggest.
Thank you for the clarification. What other possibilities could have triggered
this behavior? I am also using LVM and DRBD on top of the the md device.

Thanks,

Andrew
