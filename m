From: Matt Simonsen <matt_lists@careercast.com>
Subject: Re: software raid hangs.
Date: 08 Jul 2003 14:38:16 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1057700295.16166.54.camel@mattswrk>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
	 <200307072029.14998.bernd-schubert@web.de>
	 <200307071142330484.8AF6968B@shargaas.coreyfro.com>
	 <200307081851.31385.bernd-schubert@web.de>
	 <003401c34597$26521e40$df01010a@moon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401c34597$26521e40$df01010a@moon>
To: Donghui Wen <dhwen@protegonetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-07-08 at 14:23, Donghui Wen wrote:
> Hi,
>      I am testing software-raid with 3ware-7500 controller on a
> hot-swappable chassis.
> I found out that software-raid 5 could not even sustain 1 disk failure in
> this case.


Did you allow the array to first sync up before pulling out a disk? It
may take quite a while if you have large disks (several hours to days).

Matt

