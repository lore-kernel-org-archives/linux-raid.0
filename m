From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Thu, 29 Dec 2005 13:14:08 -0800
Message-ID: <43B451A0.1060601@zytor.com>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>	 <dlsh2c$2h0$1@sea.gmane.org> <dp1aj1$su0$1@terminus.zytor.com> <e03b90ae0512291154x1745986dqef443a6b0b4787bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0512291154x1745986dqef443a6b0b4787bc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeff@jab.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
>>The fundamental problem is that generic RS requires table lookups even
>>in the common case, whereas RAID-6 uses shortcuts to substantially
>>speed up the computation in the common case.
> 
> 
> If one wanted to support a typical 8-bit RS code (which supports a max of
> 256 drives, including ECC drives) it is already way too big to use a table. RS
> is typically done with finite field math calculations which are -
> relatively - fast
> but they are much heavier than a parity calculation. Here is one commercial
> benchmark, note the throughput numbers at the bottom of the page.
> 

Well, most of them are implemented via tables (GF log table, etc.)  They 
tend to perform poorly on modern hardware.

	-hpa
