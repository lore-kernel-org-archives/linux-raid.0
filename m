From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Mon, 5 Mar 2012 12:38:06 +0100
Message-ID: <20120305123806.ee01dd22b03c393314af12c9@bbaw.de>
References: <4F4C9A11.9060302@profihost.ag>
	<4F4F4B1D.4050000@redhat.com>
	<4F4F4EB3.6030909@profihost.ag>
	<4F4F519E.7040206@redhat.com>
	<4F508864.4050600@profihost.ag>
	<20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
	<4F508EB6.2030101@profihost.ag>
	<4F5091BF.1000102@anonymous.org.uk>
	<4F509402.8070503@profihost.ag>
	<4F50ABA3.1070603@anonymous.org.uk>
	<4F50C7DC.3000700@profihost.ag>
	<20120302163236.3555fec1296cbe30d8d37972@bbaw.de>
	<4F547038.7060009@profihost.ag>
	<4F54899A.4040301@anonymous.org.uk>
	<20120305111402.e63fee5b49046ed146cb9dcc@bbaw.de>
	<4F54A42A.4020903@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F54A42A.4020903@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mon, 05 Mar 2012 11:31:54 +0000
John Robinson <john.robinson@anonymous.org.uk> schrieb:
> > You mean if Stefan would have used an old fashioned partition table
> > inside a Linux SW-RAID with metadata 1.2, grub would have booted like
> > normal?
> 
> Yes, both grub2 and grub legacy (0.97) read partition tables. Only grub2 
> can really read inside RAID arrays - any metadata, any RAID level - [...]

Does grub2 also read partitions inside SW-RAID if the RAID consists of
partitions?
How deep works this mechanism?

DISK => partitions => RAID => partition table => RAID => .... 

Lars
