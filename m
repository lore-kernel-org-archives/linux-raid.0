From: Foster_Brian@emc.com
Subject: RE: mdadm 3.1.1  fails to hot remove device - No such device or address
Date: Fri, 26 Feb 2010 10:41:07 -0500
Message-ID: <D27CA15508148C428A25104ADEFAAC81057285C9@CORPUSMX50C.corp.emc.com>
References: <D27CA15508148C428A25104ADEFAAC8105728535@CORPUSMX50C.corp.emc.com> <20100226144220.GA24333@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20100226144220.GA24333@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Robin Hill
> Sent: Friday, February 26, 2010 9:42 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: mdadm 3.1.1 fails to hot remove device - No such device
or
> address
> 
> On Fri Feb 26, 2010 at 08:37:51AM -0500, Foster_Brian@emc.com wrote:
> 
> > Hi Neil,
> >
> > We run mdadm in a NAS framework and recently updated to 3.1.1 after
> > using older revs for quite some time. We recently observed an issue
> > where we've been unable to hot remove a failed device from an array,
> > where that member device has been physically removed from the
system.
> > 'mdadm /dev/md# -r /dev/sdg#' returns a "No such device or address
> > error."
> >
> > It turns out this occurs due to the dev_open() call added in the
code
> > referenced below. The hot remove works as expected if we revert this
> > change with the patch shown below. Was the dev_open() added for some
> > functional reason I'm not aware of (i.e., are we now breaking some
> > other error path by doing this)? For future reference, is there a
> > better way to handle the situation where the member device is
> > physically gone? Note that we currently have a static set of
> devnodes;
> > no udev or anything like that. Thanks.
> >
> Does "-r failed" or "-r detached" not work?  That should be the
easiest
> way to remove failed/detached drives from the array.
> 

Hmm, this sounds like what I'm missing. I'll try it when I have access
to the system again. Thanks!

Brian
