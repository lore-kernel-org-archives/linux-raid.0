From: Chris Allen <chris@cjx.com>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Sat, 28 Oct 2006 22:46:52 +0100
Message-ID: <4543CFCC.50109@cjx.com>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>	 <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>	 <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>	 <Pine.LNX.4.56.0610171944530.5144@lion.drogon.net> <df1ef2450610171519r6ee6da3dv3fb2dd479d0431a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df1ef2450610171519r6ee6da3dv3fb2dd479d0431a6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Andrew Moise wrote:
> On 10/17/06, Gordon Henderson <gordon@drogon.net> wrote:
>> I have had problems with XFS, but that was about 2 years ago, so things
>> might have improved by then.
>
>  Well, filling some random files with zeroes because of an unclean
> shutdown is still defined as "correct" behavior in XFS.  That hasn't
> changed that I've heard of.  Why they haven't implemented something
> akin to "data=ordered" is a mystery to me.
>  I guess I'm begging to start a filesystem flamewar at this point :-).

I can consistently crash XFS over md (kernel panic) using a simple 
forking perl
script that copies large numbers of files about. The response from the 
XFS mailing
list was a shrug and a "well don't do that then..". Problem is, this 
exactly what
the clients of my machines *will* do. I can't crash ext3 in this way no 
matter
what I do.

>
>> After your comment about ext3 max FS size, I had a bit of a oo-er
>> situation so had to do a bit of looking to make sure I was OK, and it
>> seems that 16TB is the current limit, so OK there for a while, at 
>> least...
>> (/usr/src/linux/documentation/filesystems/ext2.txt)
>
>  Aah, great news.  Different sources differ on what the max size is,
> so I was pessimistically assuming it might be as low as 2TB.  Thanks.
> -

The max in mainstream kernels is 8TB. mm kernels will support 16TB.


