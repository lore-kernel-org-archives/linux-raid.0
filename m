From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is my RAID broken?
Date: Wed, 08 Nov 2006 12:07:46 -0500
Message-ID: <45520EE2.3010105@tmr.com>
References: <e50d039c0611042329m29046e6fjf56a8f52a82294ad@mail.gmail.com> <17742.25624.469667.437194@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17742.25624.469667.437194@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Robert Hulme <rob@robhulme.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Sunday November 5, rob@robhulme.com wrote:
>  
>
>>If its resyncing that means it detected an error, right?
>>    
>>
>
>Not a disk error.  'resyncing' means that at startup it looked like
>the array hadn't been shutdown properly so it is making sure that all
>the redundancy in the array is consistent.
>
>So it looks like you machine recently crashed (power failure?) and
>it is restarting.
>
There is always the possibility that shutdown scripts don't do the right 
thing, as well. I believe one of the major distros showed this problem 
within the last few months, depending on the RAID options used.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

