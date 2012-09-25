From: <jakub@gooseman.cz>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two disks,
 causing silent data corruption
Date: Tue, 25 Sep 2012 11:48:34 +0200
Message-ID: <152edbf7bdad33717477f174f94116b7@192.168.93.35>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown> <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 25 Sep 2012 07:00:44 +0200 (CEST), Mikael Abrahamsson
<swmike@swm.pp.se> wrote:
> On Tue, 25 Sep 2012, NeilBrown wrote:
> 
>> Why do you say that "the write IO errors are invisible for the 
>> filesystem"? They are certainly reported in the kernel logs that you 
>> should and I'm sure an application would see them if it checked return 
>> status properly.
>>
>> md is behaving as designed here.  It deliberately does not fail the 
>> whole array, it just fails those blocks which are no longer accessible.
> 

Would you please refer to some documentation that this behaviour is
correct? I now tried to fail several disks in raid5, raid0 and raid10-near,
in case of r0 and r10n, mdadm didn't even allow me to remove more disks
than is sufficient to access all the data. In case of r5 I was able to fail
2 out of 3, but the array was correctly marked as FAILED and couldn't be
accessed at all. I'd expect that behaviour even in my case of raid10-far. I
can't even assmenble and run it with less than required count of disks.


> I would imagine OP would be helped by mounting filesystem with 
> "errors=remount-ro" to make sure the filesystem stops writing to the 
> drives upon errors.

Yes it's a good point.

