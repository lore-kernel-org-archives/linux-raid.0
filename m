From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 2 Mar 2012 16:32:36 +0100
Message-ID: <20120302163236.3555fec1296cbe30d8d37972@bbaw.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F50C7DC.3000700@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stefan,

the metadata versions 1.0 and 1.1 and 1.2 are the same but for the position of
the metadata on disk. Simply use metadata version 1.0 and everything works as
with 0.9.

Grub does to read partition tables inside raid devices.
Because a raid1 with metadata 1.0 or 0.9 looks like a plain disk to grub it
can read a partition table like there was no raid array.

Simply give it a try.

Lars
