From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 00:00:40 +0200
Message-ID: <ivvltm$fn9$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom De Mulder wrote:
> Maybe I should have specified--my particular aim is to try and use 
> (fairly high-end) consumer SSDs for "enterprise" server applications

That's exactly what we do.
After all, "RAID" is still the acronym for "Redundant Array of 
_Inexpensive_ Disks", no matter how many times big-$$$ will try to tell 
you otherwise.

And a software RAID built from some cheap consumer SSDs easily 
outperforms those overpriced "enterprise class" SSD devices they try to 
sell you.


> Most hardware RAID controllers that I know 
> of don't pass on the TRIM command 

Not only that, they also suck regarding adding lots of latency to the 
SSD communication.
There simply is no reason anymore to use hardware RAID at all.

Regards,

Lutz Vieweg

