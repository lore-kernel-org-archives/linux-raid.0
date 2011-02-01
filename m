From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 01 Feb 2011 13:10:06 +0000
Message-ID: <4D48062E.9040405@anonymous.org.uk>
References: <20110131201823.GA15704@lazy.lzy> <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com> <20110131222348.GA15912@lazy.lzy> <AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com> <20110131230703.GA16834@lazy.lzy> <4D4765B2.7090002@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4765B2.7090002@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/02/2011 01:45, Phillip Susi wrote:
> On 01/31/2011 06:07 PM, Piergiorgio Sartor wrote:
>> That's interesting information. I suspected something
>> like async access could have happened.
>> Is this confirmed? Are the requests from md to the
>> device layer asynchronous?
>
> Yes, it sends down requests to all drives simultaneously to achieve
> maximum performance. This is the main purpose of raid-5.
>
>> How about libata? Does this serialize wake ups?
>
> It doesn't. It will wake them all up at once.
>
> If you want to force serial wakeup, you would need to do some hacking in
> libata or the scsi layer to only allow one wakeup request at once. Of
> course, with a 6 disk raid where each disk takes 6 seconds to spin up,
> you will be waiting 36 seconds to get your data. Not exactly desirable.

That'd be an excessive amount of time to wait. A quarter of a second is 
more than enough, a tenth of a second would probably be enough. It's 
just the motor inrush current you're trying to avoid having simultaneously.

So waiting another second for your array to wake up would mean you could 
use a sensibly-sized PSU operating in its 80%+ efficiency range, rather 
than a huge PSU operating inefficiently.

Cheers,

John.

