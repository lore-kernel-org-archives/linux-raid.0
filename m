From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Thu, 25 Jul 2013 13:44:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se>
References: <loom.20130725T120703-146@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130725T120703-146@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wes <wt75@gazeta.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Jul 2013, Wes wrote:

> Why raid10 driver from Centos 6 has a 300% slower random write performance
> (random read stays the same) than Centos 5?
>
> Please share your ideas.

If my research is correct, centos5 is 2.6.18 kernel and centos6 is 2.6.32 
kernel?

So just guessing, although my experience with this was from using a 
filesystem which it seems you are not doing?

https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/writebarr.html
http://monolight.cc/2011/06/barriers-caches-filesystems/

Does seekmark use barriers to assure that data has actually been written? 
In that case it could be that 2.6.18 has different behaviour from 2.6.32 
when it comes to barriers and that explains the speed difference.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
