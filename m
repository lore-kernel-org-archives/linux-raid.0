From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 19:09:40 -0400
Message-ID: <471E7F34.4000402@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <18200.56684.14194.630264@stoffel.org>	 <1192813877.1666.79.camel@firewall.xsintricity.com>	 <18200.63987.514073.184865@stoffel.org>	 <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192830129.1666.103.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Iustin Pop <iusty@k1024.org>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Fri, 2007-10-19 at 23:23 +0200, Iustin Pop wrote:
>   
>> On Fri, Oct 19, 2007 at 02:39:47PM -0400, John Stoffel wrote:
>>     
>>> And if putting the superblock at the end is problematic, why is it the
>>> default?  Shouldn't version 1.1 be the default?  
>>>       
>> In my opinion, having the superblock *only* at the end (e.g. the 0.90
>> format) is the best option.
>>
>> It allows one to mount the disk separately (in case of RAID 1), if the
>> MD superblock is corrupt or you just want to get easily at the raw data.
>>     
>
> Bad reasoning.  It's the reason that the default is at the end of the
> device, but that was a bad decision made by Ingo long, long ago in a
> galaxy far, far away.
>
> The simple fact of the matter is there are only two type of raid devices
> for the purpose of this issue: those that fragment data (raid0/4/5/6/10)
> and those that don't (raid1, linear).
>
> For the purposes of this issue, there are only two states we care about:
> the raid array works or doesn't work.
>
> If the raid array works, then you *only* want the system to access the
> data via the raid array.  If the raid array doesn't work, then for the
> fragmented case you *never* want the system to see any of the data from
> the raid array (such as an ext3 superblock) or a subsequent fsck could
> see a valid superblock and actually start a filesystem scan on the raw
> device, and end up hosing the filesystem beyond all repair after it hits
> the first chunk size break (although in practice this is usually a
> situation where fsck declares the filesystem so corrupt that it refuses
> to touch it, that's leaving an awful lot to chance, you really don't
> want fsck to *ever* see that superblock).
>
> If the raid array is raid1, then the raid array should *never* fail to
> start unless all disks are missing (in which case there is no raw device
> to access anyway).  The very few failure types that will cause the raid
> array to not start automatically *and* still have an intact copy of the
> data usually happen when the raid array is perfectly healthy, in which
> case automatically finding a constituent device when the raid array
> failed to start is exactly the *wrong* thing to do (for instance, you
> enable SELinux on a machine and it hasn't been relabeled and the raid
> array fails to start because /dev/md<blah> can't be created because of
> an SELinux denial...all the raid1 members are still there, but if you
> touch a single one of them, then you run the risk of creating silent
> data corruption).
>
> It really boils down to this: for any reason that a raid array might
> fail to start, you *never* want to touch the underlying data until
> someone has taken manual measures to figure out why it didn't start and
> corrected the problem.  Putting the superblock in front of the data does
> not prevent manual measures (such as recreating superblocks) from
> getting at the data.  But, putting superblocks at the end leaves the
> door open for accidental access via constituent devices when you
> *really* don't want that to happen.
>   

You didn't mention some ill-behaved application using the raw device 
(ie. database) writing just a little more than it should and destroying 
the superblock.
> So, no, the default should *not* be at the end of the device.
>
>   
You make a convincing argulemt.
>> As to the people who complained exactly because of this feature, LVM has
>> two mechanisms to protect from accessing PVs on the raw disks (the
>> ignore raid components option and the filter - I always set filters when
>> using LVM ontop of MD).
>>
>> regards,
>> iustin
>>     


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

