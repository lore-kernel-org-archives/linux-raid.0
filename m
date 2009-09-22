From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: recommended 4port SATA controller ?
Date: Tue, 22 Sep 2009 14:05:30 +0000 (UTC)
Message-ID: <h9alja$e1m$3@ger.gmane.org>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
	<87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
	<4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at> <20090917215240.GA418@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Sep 2009 16:52:40 -0500, Matt Garman wrote:

> But, if, for example, you are serving the data strictly over the network
> (i.e. a NAS box), a single Gigabit ethernet connection tops out at
> rougly 125 MB/s.  So in this case the network performance would shadow
> the reduced performance of the drives on the PCI bus. (Unless your
> network controller is also on the PCI bus, then you're hosed!  It's
> always good to check the block diagram of the motherboard.)

Or unless you're using RAID5/6 with a write-intensive application. :-/

