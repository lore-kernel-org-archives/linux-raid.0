From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery from linear array (Intel SS4000-E)
Date: Fri, 14 Oct 2011 22:15:29 -0400
Message-ID: <4E98ECC1.8080403@turmel.org>
References: <4E972C82.1020605@gmx.de> <4E97539D.8040007@turmel.org> <4E985902.1070606@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E985902.1070606@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Moos <jmoos@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/14/2011 11:45 AM, Johannes Moos wrote:
> Hi Phil,
> thanks for your help!
> 
> On 13.10.2011 23:09, Phil Turmel wrote:
>> You *do* understand that "linear" has *no* redundancy? If you can't read anything at all off the bad drive, that fraction of your data is *gone*. As a linear array, files that are entirely allocated on the other three are likely to be recoverable. 
> Yes, 500GB are gone for sure. It's just about recovering what's left on the three working drives.
>> Create a zeroed placeholder file for the missing drive (must be exactly the right size):
>>
>> dd if=/dev/zero of=Disk2_Partition3.fake bs=512 count=624353185
> OK, one 500GB drive is dead (I had 2x320GB and 2x500GB), so I modified the line to
> dd if=/dev/zero of=Disk2_Partition3.fake bs=512 count=$((499703758848/512))
> because Partition 3 on that drive was 499703758848 bytes
>> mdadm --create --metadata=0.90 --level=linear -n 4 /dev/md0 /dev/loop{0,1,2,3}
> I think I need --chunk=64 as well because mdadm defaults to 512kb and the Intel box uses 64kb?
> http://www.intel.com/support/motherboards/server/ss4000-e/sb/CS-029880.htm

Yes, indeed.  I missed the "Rounding: 64K" in your mdadm -E report.

Phil
