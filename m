From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: number of global spares?
Date: Wed, 28 Sep 2005 15:11:16 -0400
Message-ID: <433AEAD4.3070801@tmr.com>
References: <1125082848.25483.23.camel@seki.nac.uci.edu> <17167.40479.3220.155672@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17167.40479.3220.155672@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Dan Stromberg <strombrg@dcs.nac.uci.edu>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

>On Friday August 26, strombrg@dcs.nac.uci.edu wrote:
>  
>
>>I've been working on a RAID setup with dual RAID controllers and
>>three expansion boxes - 48 disks in all, including data, parity and
>>global spares.
>>    
>>
>
>If there are 48 drives, why do your drive-numbers go up to 59?
>Confusing but not important.
>
>Presumably these are 360G drives (or there abouts) and you are hoping
>to use about 42 for data and the remaining 6 for redundancy.
>
>I feel this a bit tight but could be workable.
>
>If you were using Linux-soft-raid, I would probably suggest 3 16-drive raid6
>arrays, possibly making 1 a 15 drive raid6 so there is one global spare.
>However I gather you are using hardware RAID - do the controllers
>support RAID6 ??
>  
>
>>Please be sure to use a fixed-pitch font when viewing the tables found
>>below.  BTW, if people weren't so terrified of HTML, I could just make a
>>nice HTML table for easy reading without silly font requirements...
>>    
>>
>
>You mean some mail readers use variable-width-fonts to display
>text/plain?  How broken!
>  
>
Some clients actually do what the user asks in 'preferences' which may 
not be fixed fonts...

More to the point, is there a nice widely accepted calculation for 
reliability vs. MTBF? I started to develop one but stopped because it 
isn't really much use without the S.D. of the MTBF. If drive MTBF is 
equal, the better drive (safer) is one with more S.D. rather than a 
clustering of failures which somewhat increases the chance of a failure 
during rebuild.

The better the quality control the higher the risk of failure clusters, 
unfortunately.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

