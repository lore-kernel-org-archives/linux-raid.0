From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Sat, 29 Mar 2008 16:25:31 -0400
Message-ID: <47EEA5BB.5080106@tmr.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>	 <20080325233649.GA632@rap.rap.dk>	 <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com>	 <20080326072416.GA8674@rap.rap.dk>	 <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>	 <20080326192935.GB18621@rap.rap.dk> <47EAACAB.7070203@tmr.com> <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Christian Pernegger wrote:
>>  After doing a little research, I see that the original slowest form of PCI
>>  was 32 bit 33MHz, with a bandwidth of ~127MB/s.
>>     
>
> That's still the prevalent form, for anything else you need an (older)
> server or workstation board. 133MB/s in theory, 80-100MB/s in
> practice.
>
>   
I just looked at a few old machine running here, ASUS P4P800 (P4-2.8 
w/HT), P5GD1 (E6600), and A7V8X-X (Duron) boards, all 2-5 years old, and 
lspci shows 66MHz devices on the bus of all of then, and the two Intel 
ones have 64-bit devices attached.
>>  The most common hardware used the v2.1 spec, which was 64 bit at 66MHz.
>>     
>
> I don't think the spec version has anything to do with speed ratings, really.
>
>   
That was the version which included 66MHz and 64-bit. I believe any 
board using 184, 200, or 240 (from memory) RAM is v2.1, and probably 
runs a fast bus. Pretty much anything not using PC-100 memory. See 
wikipedia or similar about the versions.
>>  I would expect operation at UDMA/66
>>     
>
> What's UDMA66 got to do with anything?
>
>   
Sorry, you said this was a PATA system, I was speculating that your 
drives were UDMA/66 or faster. Otherwise the disk may be the issue, not 
the bus. Note: may... be.
>>  Final thought, these drives are paired on the master slave of the same
>>  cable, are they? That will cause them to really perform badly.
>>     
>
> The cables are master-only, I'm pretty sure the controller doesn't
> even do slaves.
>
>   
Good, drop one possible issue.
> To wrap it up
> - on a regular 32bit/33Mhz PCI bus md-RAID10 is hurt really badly by
> having to transfer data twice in every case.
> - the old 3ware 7506-8 doesn't accelerate RAID-10 in any way, even
> though it's a hardware RAID controller, possibly because it's more of
> an afterthought.
>
>
> On the 1+0 vs RAID10 debate ... 1+0 = 10 is usually used to mean a
> stripe of mirrors, while 0+1 = 01 is a less optimal mirror of stripes.
> The md implementation doesn't really do a stacked raid but with n2
> layout the data distribution should be identical to 1+0 / 10.
>   

The md raid10,f2 generally has modest write performance, if U is a 
single drive speed, write might range between 1.5U to (N-1)/2*U 
depending on tuning. Read speed is almost always (N-1)*U, which is great 
for many applications. Playing with chunk size, chunk buffers, etc, can 
make a large difference in write performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


