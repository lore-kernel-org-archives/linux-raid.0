From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Adaptec 2405 : hardware or software raid?
Date: Mon, 25 May 2009 09:52:30 -0700
Message-ID: <1243270350.11073.16.camel@cichlid.com>
References: <20090525173201.25dc3f35@hydro.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090525173201.25dc3f35@hydro.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2009-05-25 at 17:32 +0200, Janek Kozicki wrote:
> Hi,
> 
> I've bought the cheap Adaptec 2405 SAS controller for the sole
> purpose of using 15k rpm HDDs. It turns out that to expose the HDDs
> to the system I must first launch the computer from enclosed CD and
> create some logical volumes. Those logical volumes can mix HDDs in
> various raid configurations (1,0,10,5) and expose a single
> device, eg. /dev/sda from multiple HDDs.
> 
> This is the first time when I see the "logical volumes" option
> mandatory. I was planning to access the HDDs directly and create
> software raid on them with mdadm.

This datasheet says JBOD is available (Just a Bunch of Disks - exposing
the raw disks to the OS)

http://adaptec.com/en-US/products/Controllers/Hardware/sas/entry/SAS-2405/_details/Series2_datasheet.htm?nc=/en-US/products/Controllers/Hardware/sas/entry/SAS-2405/_details/Series2_datasheet.htm

main page

http://adaptec.com/en-US/products/Controllers/Hardware/sas/entry/SAS-2405/

