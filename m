From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 08:20:02 -0500
Message-ID: <4D932E02.50407@hardwarefreak.com>
References: <20110330080823.GA9167@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330080823.GA9167@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Louis-David Mitterrand put forth on 3/30/2011 3:08 AM:
> Hi,
> 
> I am seeing horrific performance on a Dell T610 with a LSISAS2008 (Dell
> H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm raid6.
> 
> The LSI card is upgraded to the latest 9.00 firmware:
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas9211-8i/index.html
> and the 2.6.38.2 kernel uses the newer mpt2sas driver.
> 
> On the T610 this command takes 20 minutes:
> 
> 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  22.64s user 3.34s system 2% cpu 20:00.69 total
> 
> where on a lower spec'ed Poweredge 2900 III server (LSI Logic MegaRAID
> SAS 1078 + 8 x Hitachi Ultrastar 7K1000 in mdadm raid6) it takes 22
> _seconds_:
> 
> 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  16.40s user 3.22s system 86% cpu 22.773 total
> 
> Besides hardware, the other difference between servers is that the
> PE2900's MegaRAID has no JBOD mode so each disk must be configured as a
> "raid0" vdisk unit. On the T610 no configuration was necessary for the
> disks to "appear" in the OS. Would configuring them as raid0 vdisks
> change anything?

Changing the virtual disk configuration is a question for Dell support.
 You haven't provided sufficient information that would allow us to
troubleshoot your problem.  Please include relevant log and dmesg output.

-- 
Stan
