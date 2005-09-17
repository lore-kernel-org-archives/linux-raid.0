From: "Jonathan Schmidt" <jon@impact-ltd.ca>
Subject: Re: raidreconf error (bug)
Date: Fri, 16 Sep 2005 19:56:55 -0700
Message-ID: <dgg0la$jlr$1@sea.gmane.org>
References: <dgckbo$her$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just thought I'd let everyone know that the problem has been solved by 
reversing the old and new raidtab files in the command line to raidreconf 
(after fixing the bug that causes the immediate abort).

The old 4-disk array is currently running with the filesystem intact.  I'll 
go about backing it up now :)

"Jonathan Schmidt" <jon@impact-ltd.ca> wrote in message 
news:dgckbo$her$1@sea.gmane.org...
>I just attempted to add a 5th 80GB disk to my RAID-5 array using 
>raidreconf. I previously added a 4th disk 6 months ago using the identical 
>tools with no errors or hiccups whatsoever.  Back then, I made a full 
>backup because of all the warnings.  This time, I assumed it would work 
>since it did last time, and did not backup the data.  You can see where 
>this is going...
>
> Here's some of the relevant info:
> .... 



