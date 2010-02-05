From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Fri, 05 Feb 2010 12:40:22 -0500
Message-ID: <4B6C5806.9040108@tmr.com>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com> <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com> <4B698365.1040007@anonymous.org.uk> <4B6C3B7D.2090502@tmr.com> <4B6C4E7F.2080501@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6C4E7F.2080501@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 05/02/2010 15:38, Bill Davidsen wrote:
>> John Robinson wrote:
> [...]
>>> What sums I've done, on the basis of a 1 in 10^15 bit unrecoverable 
>>> error rate, suggest you've a 1 in 63 chance of getting an 
>>> uncorrectable error while reading the whole surface of their 2TB 
>>> disc. Read the whole disc 44 times and you've a 50/50 chance of 
>>> hitting an uncorrectable error.
>>>
>> Rethink that, virtually all errors happen during write, reading is 
>> non-destructive, in terms of what's on the drive. So it's valid after 
>> write or it isn't, but having been written correctly, other than 
>> failures in the media (including mechanical parts) or electronics, 
>> the chances of "going bad" are probably vanishingly small.
>
> They're quite small, at 1 in 10^15 bits read. On 1GB discs, you 
> probably could call it vanishingly small. But now with 1TB and larger 
> discs, I wouldn't characterise it as vanishingly small. It's entirely 
> on the basis of the given specs that I did my calculations.
>
> Bear in mind that the operation of the disc is now deliberately 
> designed to use ECC all the time. Have a look at the vast numbers you 
> get from the SMART data for ECC errors corrected. I just checked a 
> 160GB single-platter disc with 4500 power-on hours; it quotes 
> 200,000,000 hardware ECC errors recovered.

I don't know how to read the POH smart reports for Seagate, I just 
checked a server which has been up 167 days most recently, and all but 
two weeks (moves and such) of the last four years. It shows 622 POH, and 
the others in the same raid-5 array show times from 1600 to 470. Two 
report ECC rates of 50-60m in four years, the other 6. Yes, six. None 
show any relocates. My set of WD 1TB drives showed no relocates in a 
year, and no errors (may not show that field if zero).

I keep a table of MD5sum for all significate files on the arrays, and 
haven't seen an error in years. Since I do a "check" regularly, I know 
all sectors are being read. My main issue with your post was the "read 
44 times" as explained in another reply, not your original calculation.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

