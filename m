From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: ATARAID userspace configuration tool
Date: Wed, 11 Feb 2004 07:18:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <402A39B2.1010207@backtobasicsmgmt.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>	 <1076425115.23946.18.camel@leto.cs.pocnet.net>	 <40292246.2030902@backtobasicsmgmt.com>	 <1076440714.27328.8.camel@leto.cs.pocnet.net>	 <20040211013551.GB2153@kroah.com>  <4029892C.2070009@backtobasicsmgmt.com> <1076499258.5253.1.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1076499258.5253.1.camel@leto.cs.pocnet.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christophe Saout wrote:

> Aren't the disks the ATARAID is made of usually on the same controller?
> Then you only have to scan that one.

Yes, that would be a simple optimization for this case. I was 
envisioning the future tools to handle existing MD and LVM autodetection 
and that would require looking at all potential block devices.
