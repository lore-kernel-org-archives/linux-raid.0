From: Dimitrios Apostolou <jimis@gmx.net>
Subject: Re: RAID1 and load-balancing during read
Date: Tue, 11 Sep 2007 22:10:03 +0200
Message-ID: <46E6F61B.1040001@gmx.net>
References: <200709102229.30655.jimis@gmx.net>	<20070910193530.GB2597@teal.hq.k1024.org>	<200709102251.37976.jimis@gmx.net>	<20070911034417.GA20596@teal.hq.k1024.org> <877imxibj2.fsf@informatik.uni-tuebingen.de> <46E6B533.2070006@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E6B533.2070006@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dimitrios Apostolou wrote:
> Goswin von Brederlow wrote:
>> As I understand it the problem is the hardware. Reading a chunk of
>> data from a disk means that the head has to seek to the right track
>> and the disk has to spin to the right position. After that you can
>> read a full revolution of the disk worth of data sequentially.
>>
>> Now consider what happens if you read 4K per disk in stripes. The disk
>> seeks to the right track, spins to the right position and reads
>> 4k. Then it waits for 4k to rotate below the head, read 4k, waits 4k,
>> read 4k, waits 4k, .... That way both disks are busy without any gain.
> 
> I'm not sure about that. All disks have some sort of read-ahead option. 
> Usually this read-ahead option is configurable too. What if the 
> read-ahead was set to 2*chunk size (for RAID1 with 2 disks). The 
> algorithm for reading in parallel from both disks would then be:
> 
> 1st disk:
> current_pos1= read(chunk_size)
> seek(current_pos1 + chunk_size)
> 
> 2nd disk:
> seek(current_pos2+chunk_size)
> current_pos2= read(chunk_size)
> 
> 
> Of course if drive read-ahead works properly (which should be for small 
> values) the seek() functions would not really cause the drive to seek.
> 
> As for the example you mentioned I'm quite sure that reading 4K from a 
> drive and then seeking 4K forward and reading again would not result in 
> any slowdown, since most of today's IDE drives have a default read-ahead 
> of 128KB.
> 
On a second thought I realise that this doesn't work as expected... Even 
though this will not cause slowdown, it will not cause speedup either. 
It is obvious that if a drive reads sequentially with 40MB/s, it won't 
surpass that speed no matter what seeks you do. Readahead might help to 
avoid disk head seeks, but read speed just can't increase. I don't know 
what I was thinking when writing this... :-s


Thanks for your replies,
Dimitris
