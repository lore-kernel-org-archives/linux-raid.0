From: "Jason C. Leach" <jleach@ocis.net>
Subject: Re: Stripe Block Size.
Date: Mon, 05 Apr 2004 09:58:48 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40719048.70705@ocis.net>
References: <40718078.7010303@ocis.net> <1081180986.4745.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1081180986.4745.4.camel@localhost.localdomain>
To: gulickconsulting@direcway.com, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Gulick wrote:

>On Mon, 2004-04-05 at 10:51, Jason C. Leach wrote:
>  
>
>>hi,
>>
>>I have a Promise SX6000 in a RAID5 using Linux Debian on an AMD 
>>AthelonXP 2500+.  This array will store mostly GIS data. So about 30% 
>>large files (a few hundred megs) and 70% small files (several megs).  I 
>>am curious what stripe block size to use 4-64k (the fs is reiserfs).  I 
>>was thinking 32k for the stripe block size.
>>
>>Thanks,
>>J.
>>    
>>
>
>J,
>
>If the large files are Audio/Video for streaming, then you will want a
>larger stripe size.  If not, go with the smallest that you can (a small
>~.h or text file will take the same amount of space as your stripe
>size).
>
>The best way to set this is to consider the total volume size.  What
>will be the allocation block size be for that size of volume if it were
>on a single disk for that OS?.  Set you allocation size to be the same
>or some multiple of that value.
>
>  
>
Thanks for the reply. The total volume size will be 800G. I'm not sure 
what reiserfs/Linux would use for the block size if that were on one 
disk.  Can you give me some tips? 

A significant portion of the files will be a few megs and above, not 
really any .h or other small text files (say 1%).  No streaming 
audio/vid. The GIS data will be csv files, shape files, large TIF 
files.  Is it better to go smaller then larger with the stripe block size?

Thanks,
J.

