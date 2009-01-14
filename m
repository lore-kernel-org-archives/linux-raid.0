From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 17:08:32 +0200
Message-ID: <496DFFF0.2060807@fastmail.co.uk>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan> <496DE2BD.6070905@fastmail.co.uk> <496DE763.9010300@fastmail.co.uk> <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan> <496DF771.4010407@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496DF771.4010407@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
>>
>> If that does not work, clean the drive out manually after removing it 
>> as a spare from the array:
>> dd if=/dev/zero of=/dev/sdi bs=1M
> This is taking forever
I stopped it after about half an hour, hoping that it had made garbage 
of whatever was the problem.

I then added it into the array and it worked as before.

However, it still wasn't added when I rebooted.

...but, there is something different. Now, when I --examine /dev/sdi, it 
gives output for the whole array including 2 spares, which is the end 
result I expect :

 Active Devices : 6
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 2

However, --detail /dev/md2 still denies /dev/sdi exists :

 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

What's up?

Max.

