From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5
Date: Sat, 24 Apr 2010 03:47:27 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1004240340510.6768@uplift.swm.pp.se>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>  <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>  <4BCEFE66.6010607@tmr.com>  <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>  <4BD1AE0C.2040003@msgid.tls.msk.ru>
 <o2u4877c76c1004231357x649c5979ncd3e10ea8e6060d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <o2u4877c76c1004231357x649c5979ncd3e10ea8e6060d1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Bill Davidsen <davidsen@tmr.com>, Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Apr 2010, Michael Evans wrote:

> devices, but now everyone is selling SDDs which are broken for such
> needs.  Any ram drive units still being sold seem to be more along
> data-center grade sizes.

http://benchmarkreviews.com/index.php?option=com_content&task=view&id=308&Itemid=60

Basically it's DRAM with a battery backup and a CF slot where the data 
goes in case of poewr failure. It's a bit big and so on, but it should be 
perfect for journals... Or is this the kind of device you were referring 
to as "data center grade size"?

Some of te SSDs sold today have a capacitor for power failure as well, so 
all writes will complete, but they're not so common.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
