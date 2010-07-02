From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Fri, 02 Jul 2010 12:13:19 +0100
Message-ID: <4C2DC9CF.4030107@anonymous.org.uk>
References: <20100629201153.GA13018@localhost>	<20100630111854.006ec4d0@natsu>	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>	<20100701064044.GB6058@localhost> <20100702024927.21c4f814@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100702024927.21c4f814@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: Roman Mamedov <roman@rm.pp.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/07/2010 21:49, Roman Mamedov wrote:
> On Thu, 1 Jul 2010 14:40:44 +0800
> Shaochun Wang <scwang@ios.ac.cn> wrote:
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
> 
> That's because the first time the filesystem had to increase the file's size
> 5000 times by allocating additional 1 MB, and the second time it was just
> writing to an already allocated file. If you see such a big difference here,
> run that test 3 or more times, and discard the first run's results.

Or use a proper filesystem benchmarking tool like bonnie++ and read its 
documentation so you know what it's telling you. dd is (in my opinion) 
only really any use for testing raw device streaming write/read speed.

And no, I don't understand why you get better performance with the 
write-intent bitmap turned on, unless you said that because you saw 
something like the above (as Roman says, your initial conditions were 
different so it's not a valid comparison). Usually, you need to tweak 
the write-intent bitmap's chunk size to suit your array and desired 
recovery speed to avoid it killing performance. I use a 16MB chunk on 
arrays with a few cheap drives, others go as high as 128MB on arrays 
with lots of high-performance quality drives.

Cheers,

John.
