From: "Tim Grant" <tgrant@net-itech.com>
Subject: RE: Hard drive Reliability?
Date: Thu, 20 May 2004 09:32:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006601c43e6e$edad2a90$180aa8c0@johnny>
References: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Has anyone tried to Maxline drives from Maxtor?  I know the MTBF for
most IDE hard drives is calculated for 8 hours a day, 5 days a week, and
we all know none of us are doing that.  We meet with Maxtor and they
were speaking of their new Maxline drive which is intended for 24 hours
a day, 365 days a week.  We just started using them in our products, but
it's a little early to see if they're going to be as problematic as the
other Maxtor drives we used.


--
Tim Grant

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Thursday, May 20, 2004 8:15 AM
To: John Lange
Cc: linux-raid@vger.kernel.org
Subject: Re: Hard drive Reliability?


> I don't seem to see a footnote that says "50% of drives will fail in a

> year or less..."

properly handled, especially by the hands between you and the factory,
properly installed (with adequate airflow), they certainly won't.

> Going by the product sheet and the fact the drive has a 3 year 
> warranty you'd think you would be relatively safe. Nope...

you imply that vendors are knowingly shipping half their product that
will die within even a 1yr warranty period, and then have 
to be replaced at significant cost to the vendor.  I really can't 
see why you think they're so stupid!  the alternate explanation, which
fits the data (such as it is) perfectly well is that the 
supply chain damages the drives.

> away. Shipping new drives and having a support call to install them 
> can get very expensive not to mention down time.

so install a hot spare or two or three.

> senseless in any office with more than about 2 desktops. LTSP ( 
> www.ltsp.org ) all the way!

actually, I considered using ltsp when I built my diskless cluster, but
once I looked, I could find no real value-add there.  instead, I run
export an unmodified RH dist as a readonly root, boot with 
the usual dhcp/pxe/tftp tools, and have /var in tmpfs.

regards, mark hahn.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

