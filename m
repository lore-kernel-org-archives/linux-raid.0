From: Tim Small <tim@buttersideup.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 12 May 2010 14:06:47 +0100
Message-ID: <4BEAA7E7.9000604@buttersideup.com>
References: <4BAB8D41.4010801@gmail.com>	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>	 <4BCF4693.3020101@buttersideup.com> <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com> <4BCF52ED.3000607@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF52ED.3000607@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Mark Knecht <markknecht@gmail.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 21/04/10 20:33, Phillip Susi wrote:
> On 4/21/2010 3:01 PM, Mark Knecht wrote:
>    
>> It's unfortunate that this drive doesn't respond to APM commands either.
>>      
> Yes it is.... would be nice if they made it respond to the standard APM
> command meant to configure this kind of behavior instead of creating a
> proprietary command and dos utility to invoke it.  It's also a shame the
> drive lies about its physical sector size and has no way to turn that
> off.  Might be a nice project to reverse engineer this utility on
> windows to figure out the command it sends down and add it to hdparm.
>    

I did have a look at this a while ago (it seemed to be built with Watcom 
(now open-source) and a public-domain DOS extended along with an 
open-sourced binary-compressor - decompilation under Watcom on FreeDOS 
seemed possible), and it seems that Mark Lord has done a chunk more 
hacking on it, since there is a reference to initial support in the 
latest hdparm changelog - which you might want to take a look at....

Cheers,

Tim.
