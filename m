From: Wes <wt75@gazeta.pl>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Thu, 25 Jul 2013 12:23:26 +0000 (UTC)
Message-ID: <loom.20130725T142132-22@post.gmane.org>
References: <loom.20130725T120703-146@post.gmane.org> <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike <at> swm.pp.se> writes:

> 
> On Thu, 25 Jul 2013, Wes wrote:
> 
> > Why raid10 driver from Centos 6 has a 300% slower random write performance
> > (random read stays the same) than Centos 5?
> >
> > Please share your ideas.
> 
> ...
> Does seekmark use barriers to assure that data has actually been written? 
> In that case it could be that 2.6.18 has different behaviour from 2.6.32 
> when it comes to barriers and that explains the speed difference.
> 


Yes, the kernels are as you stated.
I used seekmark from http://learnitwithme.com/?page_id=267 
and I am not so savvy to say if it uses barriers or not.
Linear write speed (dd) is the same on centos5 and centos6. 
Just the random write (seekmark) got horrible.

I found a way to disable barriers but for filesystems only. 
As I am testing block device not sure if barriers have something to it.



