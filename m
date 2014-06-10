From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Mon, 9 Jun 2014 20:48:33 -0600
Message-ID: <19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <20140609193723.79F1B3809B0@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140609193723.79F1B3809B0@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jun 9, 2014, at 1:37 PM, Wolfgang Denk <wd@denx.de> wrote:

> Dear Chris,
> 
> In message <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> you wrote:
>> 
>> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
>> 8+0 records in
>> 8+0 records out
>> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s
> 
> This has been pointed out before - if this is a 4k sector drive, then
> you should really write in units of 4 k, not 8 x 512 bytes as you do
> here.

It worked so, why? The drive interface only accepts LBAs based on 512 byte sectors, so bs=512 count=8 is the same as bs=4096 count=1, it has to get translated into 512 byte LBAs regardless. If it were a 4096 byte logical sector drive I'd agree.

Chris Murphy