From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 16:23:32 +0200
Message-ID: <5800EA64.50902@bluewin.ch>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <5800D045.9060602@bluewin.ch> <5800E4B8.9040205@bluewin.ch>
 <20161014141000.GA23227@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161014141000.GA23227@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the advice, Andreas.

On 14/10/16 16:10, Andreas Klauer wrote:
> The main issue is performance impact... it's a tradeoff for additional
> bitmap updates each write, or long resync time after a power loss or
> similar event.
>
> If performance is not critical (e.g. it's a NAS, not a database)
> then you can enable it without worries.

Yes, it is some sort of NAS.
I also have a database for ownCloud on it but I am the only user.
And I use an USV for that machine so I am also not really concerned 
about power loss.

Best probably to roll a dice :-)


Regards,
Ramon
