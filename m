From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 00:46:47 -0400
Message-ID: <4C11BFB7.7050907@meetinghouse.net>
References: <4C1128C2.4020105@meetinghouse.net>	<20100611005743.43664e5b@natsu>	<4C11578B.8010202@meetinghouse.net>	<20100611034108.6a2cdbc4@natsu>	<4C1169CB.1030903@meetinghouse.net> <20100611085112.5f33b06f@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611085112.5f33b06f@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Thu, 10 Jun 2010 18:40:11 -0400
> Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
>
>    
>> Yes... went with internal.
>>
>> I'll keep an eye on write performance.  Do you happen to know, off hand,
>> a magic incantation to change the bitmap-chunk size? (Do I need to
>> remove the bitmap I just set up and reinstall one with the larger chunk
>> size?)
>>      
> Remove (--bitmap=none) then add again with new --bitmap-chunk.
>
>    
Looks like my original --bitmap internal creation set a very large chunk 
size initially

md3 : active raid6 sda4[0] sdd4[3] sdc4[2] sdb4[1]
       947417088 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
       bitmap: 6/226 pages [24KB], 1024KB chunk

unless that --bitmap-chunk=131072 recommendation is translates to 
131072KB (if so, are you really running 131MB chunks?)

Miles

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


