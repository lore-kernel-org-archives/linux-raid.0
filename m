From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 19:03:34 -0400
Message-ID: <471E7DC6.7050206@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.63987.514073.184865@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
> Why do we have three different positions for storing the superblock?  
>   
Why do you suggest changing anything until you get the answer to this 
question? If you don't understand why there are three locations, perhaps 
that would be a good initial investigation.

Clearly the short answer is that they reflect three stages of Neil's 
thinking on the topic, and I would bet that he had a good reason for 
moving the superblock when he did it.

Since you have to support all of them or break existing arrays, and they 
all use the same format so there's no saving of code size to mention, 
why even bring this up?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

