From: Carlos Knowlton <cknowlton@mail.fsix.com>
Subject: Re: irq timeout: status=0xd0 { Busy }
Date: Thu, 27 Jan 2005 14:53:19 -0600
Message-ID: <41F954BF.8050407@mail.fsix.com>
References: <200501270512.j0R5C1908897@www.watkins-home.com>
Reply-To: cknowlton@science.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501270512.j0R5C1908897@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for the quick response!

Guy wrote:

>Why would you fsck the failed member of a RAID5?
>You said "format", please elaborate!
>
>You should verify the disk is readable.
>  
>
Verify readable?  That is why I formatted the failed member, and did the 
fsck.  I couldn't think of a better way to do it.  However..

>It looks like your disk is bad.  But a read test would be reasonable.
>
>Try this:
>dd if=/dev/had of=/dev/null bs=64k
>
>It should complete without errors.  It will do a full read test.
>I expect it will fail.
>
>  
>
I didn't think of trying 'dd', that's a good point.  However, a moot 
point right now, the drive died last night.  *Sigh* 

Anyway, thanks for the help!

-CK

