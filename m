From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 3 Jan 2009 14:13:02 +0100
Message-ID: <200901031413.03623.bs@q-leap.de>
References: <495E01E3.9060903@sm7jqb.se> <20090102213007.GA4349@lanczos.q-leap.de> <1230949917.21115.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1230949917.21115.4.camel@localhost>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bengt@sm7jqb.se, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 03 January 2009 03:31:57 Redeeman wrote:
> On Fri, 2009-01-02 at 22:30 +0100, Bernd Schubert wrote:
> > Hello Bengt,
> >
> > sil3114 is known to cause data corruption with some disks. So far I only
> > know about Seagate, but maybe there issues with newer Samsungs as well?
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/0710.2/2035.html
> >
> > Unfortuntely this issue has been simply ignored by the SATA developers :(
> > So if you want to be on the safe side, go an get another controller.
>
> Are you sure? is this not the "15" or "slow_down" thing mentioned here:
> http://ata.wiki.kernel.org/index.php/Sata_sil ?
>

According to Jeff Garzik and Tejun Heo 3114 is not affected by the mod15 bug. 
The mod15 also help in our case, but probably we are just luckily.

https://kerneltrap.org/mailarchive/linux-kernel/2007/10/11/334985/thread


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
