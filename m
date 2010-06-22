From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Data-check brings system to a standstill
Date: Tue, 22 Jun 2010 14:50:38 -0400
Message-ID: <4C2105FE.8020201@tmr.com>
References: <4C0FCFCD.4070201@quo.to> <4C19015B.3020807@tmr.com> <4C2036CB.7090505@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C2036CB.7090505@quo.to>
Sender: linux-raid-owner@vger.kernel.org
To: Jordan Russell <jr-list-2010@quo.to>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jordan Russell wrote:
> On 6/16/2010 11:52 AM, Bill Davidsen wrote:
>   
>> Alternatively, you can try setting your io scheduler to 
>> deadline,
>>     
>
> Wow - huge difference! No "hung task" warnings, no processes stuck in
> "D" state; the system remains completely responsive throughout the
> entire check.
>
> I don't see why, though, processes are blocking for 2+ minutes on the
> simplest of I/O operations when the default CFQ scheduler is used. Isn't
> CFQ supposed to distribute I/O bandwidth in a "completely fair" manner?
> Do md checks bypass the fairness algorithm?
>
>   
The CFQ has its own idea of what is "fair" and works poorly (even 
abysmally as you saw) for some load cases.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

