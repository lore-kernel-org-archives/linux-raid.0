From: Ste <ste@phx6a.ath.cx>
Subject: Re: mdadm: bitmap size
Date: Thu, 25 May 2006 20:49:01 +0200
Message-ID: <4475FC1D.6000000@phx6a.ath.cx>
References: <446D0119.1010508@phx6a.ath.cx>	<17517.2191.803890.424144@cse.unsw.edu.au>	<91ebddcf0605211608i1145d957g65b18b3caa68cfc@mail.gmail.com> <17520.63317.693491.212555@cse.unsw.edu.au> <4472E054.5050007@phx6a.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4472E054.5050007@phx6a.ath.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ste wrote:
>> raidhotadd doesn't know anything about bitmaps.
>> If you use 'mdadm /dev/mda --add /dev/nda' you should find that it
>> works better.
>>
>> I recommend getting rid of setfaulty / raidhotadd /raidhotremove etc
>> and just using mdadm.
>>
Okay now it works really fine. You could write somewere to not mix mdadm 
and standard raidtools.

Thanks a lot!
Bye! :-)
