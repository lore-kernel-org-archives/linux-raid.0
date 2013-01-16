From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Wed, 16 Jan 2013 08:59:07 +0000
Message-ID: <50F66BDB.3000203@anonymous.org.uk>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301142052.06390.thomas@fjellstrom.ca> <50F5157A.2080308@hardwarefreak.com> <201301152231.43704.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301152231.43704.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: stan@hardwarefreak.com, Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/01/2013 05:31, Thomas Fjellstrom wrote:
> On Tue Jan 15, 2013, Stan Hoeppner wrote:
>> On 1/14/2013 9:52 PM, Thomas Fjellstrom wrote:
>> ...
>>> It is working. And I can live with it as is, but it does seem like
>>> something isn't right. If thats just me jumping to conclusions, well
>>> thats fine then. But 600MB/s+ reads vs 200MB/s writes seems a tad off.
>>
>> It's not off.  As myself and others stated previously, this low write
>> performance is typical of RAID6, particularly for unaligned or partial
>> stripe writes--anything that triggers a RMW cycle.
>
> That gets me thinking. Maybe try a test with the record test size set to the
> stripe width, that would hopefully show some more accurate numbers.

Your 7-drive RAID-6 with 512K chunk will have a 2.5MB stripe width, or 
stride, whichever is the correct term, on the basis of 5 data chunks. 
Even still, a filesystem-level test cannot guarantee to be writing 
records aligned to the array's data stripes.

If you do another benchmark, try running iostat concurrently, to see how 
many reads are happening during the write tests.

At the same time, if in the real world you're doing streaming writes of 
dozens of MB/s, I would expect that write caching would turn a good 
proportion of the writes into full-stripe writes.

Cheers,

John.

