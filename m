From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 23:13:33 +0100
Message-ID: <4C8BFF0D.6020405@anonymous.org.uk>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>	<20100910222814.CB50615242D@gemini.denx.de>	<20100911083748.14843721@notabene>	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>	<20100911090709.580f3539@notabene>	<AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>	<20100911102319.2435d878@notabene>	<AANLkTi=Ze-TPiWJNzoxma9Q3h6nHqsNAS2Osu0n+VUP=@mail.gmail.com>	<20100911144226.59ebc03d@notabene> <AANLkTin7T8rsF=XhWYTZyEwUkb5BUzK6dswVoTB-Sbbs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin7T8rsF=XhWYTZyEwUkb5BUzK6dswVoTB-Sbbs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2010 05:58, Mike Hartman wrote:
[...]
> I'm using mdadm 3.1.3 but I went ahead and swapped the lines in
> mdadm.conf anyway.

Having done that you probably ought to refresh your initrd so it 
contains your updated mdadm.conf.

Cheers,

John.
