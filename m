From: Tyler <pml@dtbb.net>
Subject: Re: raidreconf error (bug)
Date: Sun, 18 Sep 2005 02:20:30 -0700
Message-ID: <432D315E.10502@dtbb.net>
References: <dgckbo$her$1@sea.gmane.org> <dgg0la$jlr$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dgg0la$jlr$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Schmidt <jon@impact-ltd.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan Schmidt wrote:

>I just thought I'd let everyone know that the problem has been solved by 
>reversing the old and new raidtab files in the command line to raidreconf 
>(after fixing the bug that causes the immediate abort).
>
>The old 4-disk array is currently running with the filesystem intact.  I'll 
>go about backing it up now :)
>
>"Jonathan Schmidt" <jon@impact-ltd.ca> wrote in message 
>news:dgckbo$her$1@sea.gmane.org...
>  
>
>>I just attempted to add a 5th 80GB disk to my RAID-5 array using 
>>raidreconf. I previously added a 4th disk 6 months ago using the identical 
>>tools with no errors or hiccups whatsoever.  Back then, I made a full 
>>backup because of all the warnings.  This time, I assumed it would work 
>>since it did last time, and did not backup the data.  You can see where 
>>this is going...
>>
>>Here's some of the relevant info:
>>    
>>
Jonathan, did you also have the patch available for raidreconf?  Please 
attach it to your reply to the raid list, I think it would be a good 
thing to have in the archive.

Tyler.



-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.11.1/104 - Release Date: 9/16/2005

