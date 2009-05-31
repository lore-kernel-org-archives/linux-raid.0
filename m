From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Awful RAID5 random read performance
Date: Sun, 31 May 2009 13:29:38 +0100
Message-ID: <4A227832.1090808@anonymous.org.uk>
References: <4A21A938.6050907@harddata.com> <4A2222E6.2070705@msgid.tls.msk.ru> <200905310147.58119.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200905310147.58119.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/05/2009 08:47, Thomas Fjellstrom wrote:
> On Sun May 31 2009, Michael Tokarev wrote:
>> Maurice Hilarius wrote:
>>> A friend writes:
>>>
>>> On a recent machine set up with Raid5.
>>> On a AMD Phenom II X4 810, and 4GB ram.
>>> 4 Seagate 7200.12  SATA 1TB drives,
>>>
>>> I'm getting some rather impressive numbers for sequential read
>>> (300MB/s+) and write (170MB/s+) but the random read is proving to be
>>> absolutely atrocious.
>>> iostat says its going at about 0.5MB/s,
>> The key thing about random i/o is the block size.  With, say, 512bytes
>> blocks and single thread you will see less than 0.5Mb/sec.  With 64kbytes
>> blocksize it will be much better.
>>
>> To diagnose: first try the same test on bare disk without raid layer.
>> Next try to vary block size and number of concurrent threads doing I/O.
>> There's no tweaks needed really.
> 
> I happen to be the friend Maurice was talking about. I let the raid layer keep 
> its default chunk size of 64K. The smaller size (below like 2MB) tests in 
> iozone are very very slow. I recently tried disabling readahead, Acoustic 
> Management, and played with the io scheduler and all any of it has done is 
> make the sequential access slower and has barely touched the smaller sized 
> random access test results. Even with the 64K iozone test random read/write is 
> only in the 7 and 11MB/s range.
> 
> It just seems too low to me.

I don't think so; can you try a similar test on single drives not using 
md RAID-5?

The killer is seeks, which is what random I/O uses lots of; with a 10ms 
seek time you're only going to get ~100 seeks/second and if you're only 
reading 512 bytes after each seek you're only going to get ~500 
kbytes/second. Bigger block sizes will show higher throughput, but 
you'll still only get ~100 seeks/second.

Clearly when you're doing this over 4 drives you can have ~400 
seeks/second but that's still limiting you to ~400 reads/second for 
smallish block sizes.

Cheers,

John.

