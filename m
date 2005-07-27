From: Jan-Frode Myklebust <Jan-Frode.Myklebust@bccs.uib.no>
Subject: Re: 3ware + RAID5 + xfs performance
Date: Wed, 27 Jul 2005 19:36:29 +0200
Message-ID: <20050727173629.GA14879@ii.uib.no>
References: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu> <200507252134.13869.hjm@tacgi.com> <20050727092104.GA6215@ii.uib.no> <200507270915.32011.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-xfs-bounce@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <200507270915.32011.hjm@tacgi.com>
Sender: linux-xfs-bounce@oss.sgi.com
Errors-to: linux-xfs-bounce@oss.sgi.com
To: Harry Mangalam <hjm@tacgi.com>
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, Jul 27, 2005 at 09:15:31AM -0700, Harry Mangalam wrote:
> That's very impressive!  How many config iterations did you have to do to get 
> this perf? 

Not too many I think.. only tried a few tunings of stripe-unit in the
3ware CLI, and scratched my heads a few times to try to understand the
mkfs.xfs sunit/swidth-options..

> 
> I'd certainly consider GPFS but I was under the impression that it was only 
> available for IBM-branded Linux boxes w/ customized kernels.  Can you buy it 
> a la carte?

Yes, and maybe even for free from the IBM Scholars programme if you
qualify. But yes, it does require a couple of "GPFS" kernel modules,
which will typically only build for vendor kernels (i.e. not keeping
up with the latest kernel.org releases). We're running a RHEL-3 clone,
so that's not been a problem for us so far.


  -jf
