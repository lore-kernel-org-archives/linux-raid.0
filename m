From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Tue, 01 Jul 2008 11:34:19 -0400
Message-ID: <486A4E7B.50604@tmr.com>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de> <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4868E45F.30105@w1nr.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mike McCarthy <mike@w1nr.net>
Cc: Michael Bussmann <bus@mb-net.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike McCarthy wrote:
> Bill Davidsen wrote:
>>
>> Wonder if hardware or software is happening, sounds like an 
>> mishandled hardware error, but I'm guessing. I have a server with 
>> RAID1 and Fedora 2.6.22.14-72.fc6PAE kernel, up 72 days, no problems.
>>
>
> 2.6.22 is running fine.  The problems are in the 2.6.25 kernel (FC9 
> and SUSE 11.0)

Given heavy 2.6.25 use, my guess is still that the root cause of this is 
hardware, and that the change in disk code either triggers the hardware 
problem, or handles it differently. Are you by any chance running NCQ on 
your system?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


