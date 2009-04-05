From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re:
Date: Sat, 04 Apr 2009 19:45:56 -0500
Message-ID: <49D7FF44.8010309@gmail.com>
References: <20090405001223.PZXI1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405001223.PZXI1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lelsie Rhorer wrote:
>> I would try to first run hardware diagnostics.  Maybe you will get
>> "lucky" and one or more disks will fail diagnostics, which at least
>> means it will be easy to repair the problem.
>>
>> This could very well be situation where you have a lot of bad blocks
>> that have to get restriped, and parity has to be regenerated.   Are
>> these the cheap consumer SATA disk drives, or enterprise class disks?
> 
> 
> I don't buy that for a second.  First of all, restriping parity can and does
> occur in the background.  Secondly, how is it the system writes many
> terrabytes of data post file creation, then chokes on a 0 byte file?
> 


You should note that the drive won't know a sector it just wrote is 
bad until it reads it....are you sure you actually successfully wrote 
all of that data and that it is still there?

And it is not the writes that kill when you have a drive going bad, it 
is the reads of the bad sectors.    And to create a file, a number of 
things will likely need to be read to finish the file creation, and if 
one of those is a bad sector things get ugly.

