From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 16:18:34 +0400
Message-ID: <4264F71A.9070103@tls.msk.ru>
References: <1113853825.1483.34.camel@debian> <426414A5.3020706@dgreaves.com> <1113865936.1483.73.camel@debian> <20050419071514.GB29247@percy.comedia.it> <4264BC88.4050209@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4264BC88.4050209@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Luca Berra wrote:
> 
>> many people find it easier to understand if raid partitions are set to
>> 0XFD. kernel autodetection is broken and should not be relied upon.
> 
> Could you clarify what is broken?
> I understood that it was simplistic (ie if you have a raid0 built over a 
> raid5
> or something exotic then it may have problems) but essentially worked.
> Could it be :
> * broken for complex raid on raid
> * broken for root devices
> * fine for 'simple', non-root devices

It works when everything works.  If something does not work (your disk
died, you moved disks, or esp. you added another disk from another
machine wich was also a part of (another) raid array), every bad
thing can happen, from just inability to assemble the array at all,
to using the wrong disks/partitions, and to assembling the wrong
array (the one from another machine).  If it's your root device
you're trying to assemble, recovery involves booting from a rescue
CD and cleaning stuff up, which can be problematic at times.

/mjt
