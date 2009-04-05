From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE:
Date: Sat, 4 Apr 2009 19:12:20 -0500
Message-ID: <20090405001223.PZXI1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <F2C688D6A021E34CB81C0E631EF4C093017A43D1@34093-C4-EVS1.exchange.rackspace.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C093017A43D1@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I would try to first run hardware diagnostics.  Maybe you will get
> "lucky" and one or more disks will fail diagnostics, which at least
> means it will be easy to repair the problem.
> 
> This could very well be situation where you have a lot of bad blocks
> that have to get restriped, and parity has to be regenerated.   Are
> these the cheap consumer SATA disk drives, or enterprise class disks?


I don't buy that for a second.  First of all, restriping parity can and does
occur in the background.  Secondly, how is it the system writes many
terrabytes of data post file creation, then chokes on a 0 byte file?

