From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Mon, 01 Feb 2010 16:11:07 +0100
Message-ID: <4B66EF0B.5000705@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B65943A.4040800@shiftmail.org> <4B66B367.6030803@texsoft.it> <4B66CD01.7040202@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B66CD01.7040202@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo wrote:
> Giovanni Tessore wrote:
>> Maybe would be useful to have unrecoverable read errors on degraded 
>> array to:
>> 1) sent a big alert to admin, with detailed info
>> 2) don't fail the disk and whole array, but set it into readonly mode
>> 3) report read errors to the OS (as for a single drive)
>
> I think if you set it to readonly mode, it wouldn't degrade further 
> even on read error.
> I think I saw this from the source code, but now I'm not really sure 
> any more.
> Do you want to check?

I had by sure to recreate the degraded array some times because of going 
down while reading from defective sectors.
I'm not sure if always I set array to readonly (because I was quite in 
panic) ... but I'd guess I did.
I'll try to look into the code.

This has been my first bad experience with raid, I never had to go deep 
inside maintenance mode or to look into source code .. but I had to 
learn fast ;-)

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


