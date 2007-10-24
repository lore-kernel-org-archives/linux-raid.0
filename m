From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Wed, 24 Oct 2007 11:32:43 -0400
Message-ID: <471F659B.2010109@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com>	<18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com> <18207.20482.272516.461264@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18207.20482.272516.461264@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
>>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:
>>>>>>             
>
> Bill> John Stoffel wrote:
>   
>>> Why do we have three different positions for storing the superblock?  
>>>       
>
> Bill> Why do you suggest changing anything until you get the answer to
> Bill> this question? If you don't understand why there are three
> Bill> locations, perhaps that would be a good initial investigation.
>
> Because I've asked this question before and not gotten an answer, nor
> is it answered in the man page for mdadm on why we have this setup. 
>
> Bill> Clearly the short answer is that they reflect three stages of
> Bill> Neil's thinking on the topic, and I would bet that he had a good
> Bill> reason for moving the superblock when he did it.
>
> So let's hear Neil's thinking about all this?  Or should I just work
> up a patch to do what I suggest and see how that flies? 
>   

If you are only going to change the default, I think you're done, since 
people report problems with bootloaders starting versions other than 
0.90. And until I hear Neil's thinking on this, I'm not sure that I know 
what the default location and type should be. In fact, reading the 
discussion I suspect it should be different for RAID-0 (should be at the 
end) and all other types (should be near the front). That retains the 
ability to mount one part of the mirror as a single partition, while 
minimizing the possibility of bad applications seeing something which 
looks like a filesystem at the start of a partition and trying to run 
fsck on it.
> Bill> Since you have to support all of them or break existing arrays,
> Bill> and they all use the same format so there's no saving of code
> Bill> size to mention, why even bring this up?
>
> Because of the confusion factor.  Again, since noone has been able to
> articulate a reason why we have three different versions of the 1.x
> superblock, nor have I seen any good reasons for why we should have
> them, I'm going by the KISS principle to reduce the options to the
> best one.
>
> And no, I'm not advocating getting rid of legacy support, but I AM
> advocating that we settle on ONE standard format going forward as the
> default for all new RAID superblocks.
>   

Unfortunately the solution can't be any simpler than the problem, and 
that's why I'm dubious that anything but the documentation should be 
changed, or an additional metadata target added per the discussion 
above, perhaps "best1" for best 1.x format based on the raid level.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

