From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 08:15:11 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca>
References: <1085037305.10232.32.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085037305.10232.32.camel@localhost>
To: John Lange <john.lange@bighostbox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I don't seem to see a footnote that says "50% of drives will fail in a
> year or less..."

properly handled, especially by the hands between you and the factory,
properly installed (with adequate airflow), they certainly won't.

> Going by the product sheet and the fact the drive has a 3 year warranty
> you'd think you would be relatively safe. Nope...

you imply that vendors are knowingly shipping half their product
that will die within even a 1yr warranty period, and then have 
to be replaced at significant cost to the vendor.  I really can't 
see why you think they're so stupid!  the alternate explanation,
which fits the data (such as it is) perfectly well is that the 
supply chain damages the drives.

> away. Shipping new drives and having a support call to install them can
> get very expensive not to mention down time.

so install a hot spare or two or three.

> senseless in any office with more than about 2 desktops. LTSP (
> www.ltsp.org ) all the way!

actually, I considered using ltsp when I built my diskless cluster,
but once I looked, I could find no real value-add there.  instead,
I run export an unmodified RH dist as a readonly root, boot with 
the usual dhcp/pxe/tftp tools, and have /var in tmpfs.

regards, mark hahn.

