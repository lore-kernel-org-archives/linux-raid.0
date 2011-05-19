From: Michael Sallaway <michael@sallaway.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 00:06:32 +1000
Message-ID: <4DD523E8.7090109@sallaway.com>
References: <4DD50C89.8060006@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD50C89.8060006@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 19/05/2011 10:26 PM, Ed W wrote:
> So far I saw recommendations for:
>
> - LSI 1068E (SuperMicro 3081E)  (8 port 3Gb)

I'm using one of these, and it's working great. It's a Supermicro 
AOC-USASLP-L8i. I'm using all 8 ports, and another 4 drives on the 
onboard controller.

Note, however, that I was first running a slightly older kernel, and it 
didn't work (bus errors, lots of weird stuff happening), so I 
temporarily gave up on it -- I believe it was either 2.6.31 or 2.6.32 
(Ubuntu 10.04 LTS).  However, due to a need for something else, I 
upgraded to a 2.6.35 kernel, and it started working fine with that 
kernel. Been using it for ~9 months perfectly fine.

Cheers,
Michael


