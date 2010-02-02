From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Tue, 02 Feb 2010 10:11:03 -0500
Message-ID: <4B684087.50001@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>	<4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100202093738.44b4fece@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Mon, 01 Feb 2010 16:18:23 -0500
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>> Comment: when there is a three way RAID-1, why doesn't repair *vote* on 
>> the correct value instead of just making a guess?
>>
>>     
>
> Because truth is not democratic.
>
> (and I defy you to define "correct" in any general way in this context).
>   

If you are willing to accept that the reconstructed data from RAID-[56] 
is "correct" then the data from RAID-1 majority opinion is "correct." If 
you say that such recovered data is the "most likely to match what was 
written," then data consistent on (N+1)/2 drives of a RAID-1 should be 
viewed in the same light. Call it "most likely to be correct" if you 
prefer, but picking a value from a drive at random is less likely.

This whole discussion simply shows that for RAID-1 software RAID is less 
reliable than hardware RAID (no, I don't mean fake-RAID), because it 
doesn't pin the data buffer until all copies are written.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

