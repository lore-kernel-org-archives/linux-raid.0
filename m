From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Using mdadm.conf to create arrays
Date: Fri, 7 Mar 2003 10:06:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E86@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is there any way to use mdadm.conf to create arrays in addition to being
able to assemble them?  I'm creating a large number of arrays and I
would like to use mdadm to create them as well as start them at boot
time.  I've created a couple of arrays on my test system, but I want to
semi-automate the creation of arrays.  

With raidtools I can create the conf file and then do an 'mkraid
/dev/md[0-9]' and that will create those ten arrays.  Is there a way to
accomplish something similar with mdadm and mdadm.conf?

Thanks in advance for your help,
Andy.

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
