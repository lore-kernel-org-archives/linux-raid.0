From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: [Jfs-discussion] maximum filesystem size limit
Date: Wed, 9 Oct 2002 09:27:07 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021009162707.GB1148@matchmail.com>
References: <8D587D949A61D411AFE300D0B74D75D703F0BF1B@server.s8.com> <200210091153.59452.roy@karlsbakk.net> <1034158761.5865.1.camel@mdew> <200210091225.24185.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210091225.24185.roy@karlsbakk.net>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: mdew <mdew@mdew.dyndns.org>, Cameron Bahar <CBahar@s8.com>, "'jfs-discussion@www-124.ibm.com'" <jfs-discussion@www-124.southbury.usf.ibm.com>, Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 09, 2002 at 12:25:24PM +0200, Roy Sigurd Karlsbakk wrote:
> > > > Can someone please tell me if I can use JFS to create a single 12TB
> > > > filesystem under Linux?
> > >
> > > Afaik, you have a problem here concerning the Linux 2.4 maximum block
> > > device size of 2TB.
> >
> > is this "fixed" in 2.5 yet?
> 
> I beleive so

No, not Linus 2.5.  It is in Andrew Morton's -mm tree though.  That should
mean that after some heavy pounding on the code (what else would you expect
from akpm?) it will probably be in 2.5-linus soon...
