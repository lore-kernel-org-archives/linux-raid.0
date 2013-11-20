From: James Plank <plank@cs.utk.edu>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 15:30:10 -0500
Message-ID: <BD8F4758-37F1-44FC-8FB6-0F798FE626DF@cs.utk.edu>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com> <528D0913.1070604@zytor.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528D0913.1070604@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Brown <david.brown@hesbynett.no>, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

Peter, I think I understand it differently.  Concrete example in GF(256) for k=6, m=4:

First, create a 3 by 6 cauchy matrix, using x_i = 2^-i, and y_i = 0 for i=0, and y_i = 2^i for other i.  In this case:   x = { 1, 142, 71, 173, 216, 108 }  y = { 0, 2, 4).  The cauchy matrix is:

  1   2   4   8  16  32
244  83  78 183 118  47
167  39 213  59 153  82

Divide row 2 by 244 and row 3 by 167.  Then extend it with a row of ones on top and it's still MDS, and that's the code for m=4, with RAID-6 as a subset.  Very nice!  

Jim

----------

On Nov 20, 2013, at 2:10 PM, H. Peter Anvin wrote:

> On 11/20/2013 11:05 AM, Andrea Mazzoleni wrote:
>> 
>> For the first row with j=0, I use xi = 2^-i and y0 = 0, that results in:
>> 
> 
> How can xi = 2^-i if x is supposed to be constant?
> 
> That doesn't mean that your approach isn't valid, of course, but it
> might not be a Cauchy matrix and thus needs additional analysis.
> 
>> row j=0 -> 1/(xi+y0) = 1/(2^-i + 0) = 2^i (RAID-6 coefficients)
>> 
>> For the next rows with j>0, I use yj = 2^j, resulting in:
>> 
>> rows j>0 -> 1/(xi+yj) = 1/(2^-i + 2^j)
> 
> Even more so here... 2^-i and 2^j don't seem to be of the form xi and yj
> respectively.
> 
> 	-hpa
> 

