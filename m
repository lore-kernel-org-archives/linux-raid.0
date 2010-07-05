From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Sun, 04 Jul 2010 20:17:10 -0400
Message-ID: <4C312486.3040403@tmr.com>
References: <20100629201153.GA13018@localhost>	<20100630111854.006ec4d0@natsu>	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>	<20100701064044.GB6058@localhost> <20100702024927.21c4f814@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100702024927.21c4f814@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Thu, 1 Jul 2010 14:40:44 +0800
> Shaochun Wang <scwang@ios.ac.cn> wrote:
>
>   
>> 	-bash-4.1$ sudo dd if=/dev/zero of=test.dd bs=1M count=5000
>> conv=fdatasync,notrunc Password:
>> 	5000+0 records in
>> 	5000+0 records out
>> 	5242880000 bytes (5.2 GB) copied, 63.497 s, 82.6 MB/s
>>
>> 	-bash-4.1$ sudo dd if=/dev/zero of=test.dd bs=1M count=5000
>> conv=fdatasync,notrunc 5000+0 records in
>> 	5000+0 records out
>> 	5242880000 bytes (5.2 GB) copied, 18.1033 s, 290 MB/s
>> 	
>> I don't know why the second dd becomes 290MB/s and the first 82.6MB/s.
>>     
>
> That's because the first time the filesystem had to increase the file's size
> 5000 times by allocating additional 1 MB, and the second time it was just
> writing to an already allocated file. If you see such a big difference here,
> run that test 3 or more times, and discard the first run's results.
>
>   
Unless the notrunc option is used, the file is truncated and allocated 
all over again. I'm pretty sure the inode is reused, that's down in the 
noise.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

