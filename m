From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Adding a smaller drive
Date: Sun, 05 Jul 2009 23:12:47 +0100
Message-ID: <4A51255F.1020308@anonymous.org.uk>
References: <20090705220252458.BCFJ19903@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090705220252458.BCFJ19903@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/2009 23:03, Leslie Rhorer wrote:
[...]
>> I think I might take to doing that too, making my partitions/arrays
>> multiples of 1,000,000,000 bytes (a drive maker's 1GB) where possible,
>> just to be sure :-)
> 
> 	Well, that's not quite possible, of course, since sectors are
> usually 512 bytes, and 1E9 is not a multiple of 512.  Indeed, that's where
> this whole situation is ridiculous. For drive manufacturers to even consider
> using GB as a measuring basis is ludicrous.  If sectors were 1000 bytes, and
> if computer registers were base 10, it would be an entirely different
> matter, but the fact is the sector size is 2^9 and all the register
> boundaries are going to be multiples of 2, not 10.

But 10^9 is divisible by 512: 10^9 = (2*5)^9 = 2^9 * 5^9. There are 
therefore 1953125 512-byte sectors in 1 drive maker's GB.

Cheers,

John.
