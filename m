From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 19:48:33 +0800
Message-ID: <43C8E511.7090207@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <20060113144640.GA10566@lug.udel.edu> <43C851AD.80006@fastmail.co.uk> <20060114020523.GB24976@lug.udel.edu> <43C8B5A5.5010500@fastmail.co.uk> <43C8D5A1.5070004@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C8D5A1.5070004@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ross Vandegrift <ross@lug.udel.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Max Waterman wrote:
> []
>> My preference will probably be raid10 - ie raid0 2 drives, raid0
>> another 2 drives, and then raid1 both raid0s. My 5th disk can be a hot
>> spare. Round reasonable?
> 
> Nononono. Never do that.  Instead, create two raid1s and raid0
> both, ie, just the opposite.  Think about the two variants, and
> I hope you'll come to the reason why raid0(2x raid1) is more
> reliable than raid1(2x raid0). ;)

Ah, yes. Right. I was aware of the 'difference', just had it backwards
in my mind...oops.

> 
>> Alternatively, we could probably get a 6th disk and do raid1 on
>> disk #5 & #6 and install the OS on that - keeping the application
>> data separate. This would be ideal, I think. For some reason, I like
>> to keep os separate from application data.
> 
> BTW, there's a raid10 module in current 2.6 kernels, which works
> somewhat differently compared with raid0(2x raid1) etc.

oh? and how does that compare to the MD. Although I can create md devices
using mdadm, I guess I'm not completely sure what actually does the work.

Max.
