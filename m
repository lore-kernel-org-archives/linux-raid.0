From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: unreadable drives can be synchronized?
Date: Fri, 18 May 2007 17:04:15 +0200
Message-ID: <464DC06F.2080609@wpkg.org>
References: <200705181447.l4IElO2a000640@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200705181447.l4IElO2a000640@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: colin.p.mccabe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess schrieb:
>> Basically, B appears to be "write-only"; it will never return an error on a
>> write, but just try to read from it, and you will be sorry.
> 
> It would be interesting to see what SMART says about drive B, especially
> the short and long self tests.

I wouldn't rely on SMART.

I have a broken drive, which has lots of badblocks - but SMART happily 
claims it's fine (short/long tests are completed without errors).


-- 
Tomasz Chmielewski
http://wpkg.org

