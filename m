From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: issue with internal bitmaps
Date: Mon, 17 Jul 2006 14:53:07 -0400
Message-ID: <44BBDC93.6050603@tmr.com>
References: <20060706141207.GC21642@percy.comedia.it> <17581.35762.452409.927246@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.35762.452409.927246@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Thursday July 6, bluca@comedia.it wrote:
>  
>
>>hello, i just realized that internal bitmaps do not seem to work
>>anymore.
>>    
>>
>
>I cannot imagine why.  Nothing you have listed show anything wrong
>with md...
>
>Maybe you were expecting
>   mdadm -X /dev/md100
>to do something useful.  Like -E, -X must be applied to a component
>device.  Try
>   mdadm -X /dev/sda1
>
To take this from the other end, why should -X apply to a component? 
Since the components can and do change names, and you frequently mention 
assembly by UUID, why aren't the component names determined from the 
invariant array name when mdadm wants them, instead of having a user or 
script check the array to get the components?

Between udev and dynamic reconfiguration when component names have 
become less and less relevant, perhaps they can be less used in the future.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

