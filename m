From: Daniel Reurich <daniel@centurion.net.nz>
Subject: RE: Broken RAID1 boot arrays
Date: Fri, 14 May 2010 18:54:36 +1200
Message-ID: <1273820076.5140.2752.camel@localhost.localdomain>
References: <7A.77.20538.06CBCEB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7A.77.20538.06CBCEB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 2010-05-13 at 21:58 -0500, Leslie Rhorer wrote:
> > > ~ # mount -o -v  /dev/md1 /target
> > > mount: mounting /dev/md1 on /target failed: Invalid argument
> > 

>  
> > What type of filesystem is it?
> > 
> > Try "mount -v /dev/md1 /"
> 
> 	It doesn't matter what switches I try, it always gives me that
> error.  The md1 array (/boot) is ext2, and the md2 array (/) is ext3.

Is mdadm actually assembling the arrays?

what's the output of: "cat /proc/mdstat"



