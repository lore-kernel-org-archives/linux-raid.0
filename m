From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Fri, 30 May 2008 08:22:12 -0400
Message-ID: <483FF174.80602@tmr.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>	<20080528195752.0cdcbc6d@core>	<483DE40D.8090608@tmr.com> <20080529122223.462bf396@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080529122223.462bf396@core>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?ISO-8859-1?Q?Jens_B=E4ckman?= <jens.backman@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Alan Cox wrote:
>> I really don't think that's any part of the issue, the same memory and 
>> bridge went 4-5x faster in other read cases. The truth is that the 
>> raid-1 performance is really bad, and it's the code causing it AFAIK. If 
>> you track the actual io it seems to read one drive at a time, in order, 
>> without overlap.
>>     
>
> Make sure the readahead is set to be a fair bit over the stripe size if
> you are doing bulk data tests for a single file. (Or indeed in the real
> world for that specific case ;))
>   

IIRC Justin has readahead at 16MB and chunk at 256k. I would think that 
if multiple devices were used at all by the md code, that the chunk 
rather than stripe size would be the issue. In this case the RA seems 
large enough to trigger good behavior, were there are available.

Note: this testing was done with an old(er) kernel, as were all of mine. 
Since my one large raid array has become more mission critical I'm not 
comfortable playing with new kernels. The fate of big, fast, and stable 
machines is to slide into production use. :-(
I suppose that's not a bad way to do it, I now have faith in what I'm 
running.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


