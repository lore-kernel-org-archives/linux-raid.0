From: mdew <mdew@mdew.dyndns.org>
Subject: Re: [Jfs-discussion] maximum filesystem size limit
Date: 09 Oct 2002 23:19:21 +1300
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1034158761.5865.1.camel@mdew>
References: <8D587D949A61D411AFE300D0B74D75D703F0BF1B@server.s8.com>
	<200210091153.59452.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200210091153.59452.roy@karlsbakk.net>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Cameron Bahar <CBahar@s8.com>, "'jfs-discussion@www-124.ibm.com'" <jfs-discussion@www-124.southbury.usf.ibm.com>, Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2002-10-09 at 22:53, Roy Sigurd Karlsbakk wrote:
> On Tuesday 08 October 2002 23:14, Cameron Bahar wrote:
> > I need support for a single 12 TB filesystem on Linux. The documentation
> > indicates that JFS supports a theoretical 4PB limit, but that other
> > limitations (32 bit offsets) within limit prevent scaling to this large
> > size.
> >
> > Can someone please tell me if I can use JFS to create a single 12TB
> > filesystem under Linux?
> 
> Afaik, you have a problem here concerning the Linux 2.4 maximum block device 
> size of 2TB.

is this "fixed" in 2.5 yet?
