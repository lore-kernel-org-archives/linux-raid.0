From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active  devices)
Date: Tue, 15 Jul 2008 11:54:52 +1200
Message-ID: <487BE74C.8050004@sauce.co.nz>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com> <20080625161357.GH23944@skl-net.de> <18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com> <g5fam0$8oe$1@ger.gmane.org> <487B7B74.3010903@dgreaves.com> <20080714225816.GS4314@kiste.smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080714225816.GS4314@kiste.smurf.noris.de>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs wrote:

> In fact, as I said, there may be problems lurking on other disks which I
> just haven't found yet (how often do you read all 5TB of your data?),
> which means that a feature like this is the difference between being
> able to recover and certain data loss, RAID-6 nonwithstanding.

This is why scheduled "check" or "repairs" should be done - see 
Documentation/md.txt in the kernel source for details.

Regards,

Richard
