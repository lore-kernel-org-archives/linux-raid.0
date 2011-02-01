From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 20:45:22 -0500
Message-ID: <4D4765B2.7090002@cfl.rr.com>
References: <20110131201823.GA15704@lazy.lzy> <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com> <20110131222348.GA15912@lazy.lzy> <AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com> <20110131230703.GA16834@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131230703.GA16834@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/31/2011 06:07 PM, Piergiorgio Sartor wrote:
> That's interesting information. I suspected something
> like async access could have happened.
> Is this confirmed? Are the requests from md to the
> device layer asynchronous?

Yes, it sends down requests to all drives simultaneously to achieve 
maximum performance.  This is the main purpose of raid-5.

> How about libata? Does this serialize wake ups?

It doesn't.  It will wake them all up at once.

If you want to force serial wakeup, you would need to do some hacking in 
libata or the scsi layer to only allow one wakeup request at once.  Of 
course, with a 6 disk raid where each disk takes 6 seconds to spin up, 
you will be waiting 36 seconds to get your data.  Not exactly desirable.
