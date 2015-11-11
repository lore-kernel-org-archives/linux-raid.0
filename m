From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 20:03:32 -0500
Message-ID: <564293E4.6080402@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564284F5.9080409@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/2015 06:59 PM, Phil Turmel wrote:
>>> For now, use data offset 2048 for all of them.
>>
>> output of all eight combinations:
> 
> Hmmm.  Very strange.  Let's see the dump of the start of the data area of all four partitions:
> 
> for x in /dev/sd[efgh]1 ; do echo -e "\n$x\n" ; dd if=$x skip=2048 count=16 2>/dev/null |hexdump -C ; done

I just noticed your response to this didn't make it to the list.  It was
108k.  If you do it again with count=8 -- that'll be enough for everyone
to understand my other reply.

Phil

