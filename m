From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 18:45:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4029892C.2070009@backtobasicsmgmt.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk> <1076425115.23946.18.camel@leto.cs.pocnet.net> <40292246.2030902@backtobasicsmgmt.com> <1076440714.27328.8.camel@leto.cs.pocnet.net> <20040211013551.GB2153@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040211013551.GB2153@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg KH wrote:

> I really don't think udev in and of itself needs to know anything
> special about these kinds of devices, as it will be glad to kick off
> other programs for you if you want it to.

Agreed (not that I'm implementing any of this stuff :-)

The tricky part is for Thomas' ataraid-detect program to keep some 
information around when it has seen the first component of a RAID-0 but 
not the second (or vice-versa). It would be very inefficient to scan all 
known block devices every time a new one is added, although that 
brute-force method could be used just to get the program working at 
first. Once the whole idea has been tested and works properly (the 
ATARAID devices become available and function properly), the efficiency 
problem(s) could be addressed.
