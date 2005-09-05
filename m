From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: why the kernel and mdadm report differently
Date: Mon, 5 Sep 2005 08:36:41 -0400
Message-ID: <013301c5b216$78e93060$c700a8c0@NCNF5131FTH>
References: <431C0968.10301@bppiac.hu> <17180.3031.193961.445535@cse.unsw.edu.au> <431C30E3.2040404@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
> >>this is mdadm 1.12, just another site note there is no rpm for version 
> >>2.0:-(
> > 
> > 
> > No.  I seem to remember some odd compile issue with making the RPM
> > and thinking "I don't care".   Maybe I should care a bit more....
> 
> would be useful.

Not trying to be rude; but the install of mdadm is pathetically easy. 

Untar/Gzip the source; and type:

    make
    make install


-- David
