From: Christophe Saout <christophe@saout.de>
Subject: Re: ATARAID userspace configuration tool
Date: Wed, 11 Feb 2004 12:34:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076499258.5253.1.camel@leto.cs.pocnet.net>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>
	 <1076425115.23946.18.camel@leto.cs.pocnet.net>
	 <40292246.2030902@backtobasicsmgmt.com>
	 <1076440714.27328.8.camel@leto.cs.pocnet.net>
	 <20040211013551.GB2153@kroah.com>  <4029892C.2070009@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4029892C.2070009@backtobasicsmgmt.com>
To: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mi, den 11.02.2004 schrieb Kevin P. Fleming um 02:45:

> The tricky part is for Thomas' ataraid-detect program to keep some 
> information around when it has seen the first component of a RAID-0 but 
> not the second (or vice-versa). It would be very inefficient to scan all 
> known block devices every time a new one is added, although that 
> brute-force method could be used just to get the program working at 
> first. Once the whole idea has been tested and works properly (the 
> ATARAID devices become available and function properly), the efficiency 
> problem(s) could be addressed.

Aren't the disks the ATARAID is made of usually on the same controller?
Then you only have to scan that one.


