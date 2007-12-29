From: dean gaudet <dean@arctic.org>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Sat, 29 Dec 2007 14:21:03 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0712291415190.5207@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>  <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>  <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org> <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
 <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org> <Pine.LNX.4.64.0712291649250.13461@p34.internal.lan> <alpine.DEB.0.999999.0712291409400.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0712291409400.5207@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 29 Dec 2007, dean gaudet wrote:

> On Sat, 29 Dec 2007, Justin Piszcz wrote:
> 
> > Curious btw what kind of filesystem size/raid type (5, but defaults I assume,
> > nothing special right? (right-symmetric vs. left-symmetric, etc?)/cache
> > size/chunk size(s) are you using/testing with?
> 
> mdadm --create --level=5 --chunk=64 -n7 -x1 /dev/md2 /dev/sd[a-h]1
> mkfs.xfs -f /dev/md2
> 
> otherwise defaults

hmm i missed a few things, here's exactly how i created the array:

mdadm --create --level=5 --chunk=64 -n7 -x1 --assume-clean /dev/md2 /dev/sd[a-h]1

it's reassembled automagically each reboot, but i do this each reboot:

mkfs.xfs -f /dev/md2
mount -o noatime /dev/md2 /mnt/new
./dma_thrasher linux.tar.gz /mnt/new

the --assume-clean and noatime probably make no difference though...

on the bisection front it looks like it's new behaviour between 2.6.21.7 
and 2.6.22.15 (stock kernels now, not debian).

i've got to step out for a while, but i'll go at it again later, probably 
with git bisect unless someone has some cherry picked changes to suggest.

-dean
