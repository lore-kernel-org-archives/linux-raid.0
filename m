From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 12:24:32 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <40292FF0.3030504@backtobasicsmgmt.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>	 <1076425115.23946.18.camel@leto.cs.pocnet.net>	 <40292246.2030902@backtobasicsmgmt.com> <1076440714.27328.8.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1076440714.27328.8.camel@leto.cs.pocnet.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christophe Saout wrote:

> Right. dmpartx should run on dm-[0-9]* and md[0-9]* events (but not
> recursively of course ;)).

Oh I don't know, people have been asking for the ability to have 
partitioned MD devices for so long, I can see where someone may very 
well want to be able to have an MD device composed of three disks, 
broken up into LVM2 volumes, one of which contains an image of a Sun 
disk with a Solaris disklabel on it :-) For the little bit of extra time 
that dmpartx would spend looking for partition tables I don't think the 
recursion would be painful (unless dmpartx is unnecessarily noisy or 
something).
