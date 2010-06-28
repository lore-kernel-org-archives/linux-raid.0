From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: impact of one slow drive?
Date: Mon, 28 Jun 2010 09:36:29 -0400
Message-ID: <4C28A55D.80100@meetinghouse.net>
References: <EB9469C209DB064DA15714214B92D5167F23871F0F@34093-MBX-C09.mex07a.mlsrvr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EB9469C209DB064DA15714214B92D5167F23871F0F@34093-MBX-C09.mex07a.mlsrvr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> David Lethe wrote:
>> -----Original Message-----<edited for brevity>
>>
>> From:  "Miles Fidelman"<mfidelman@meetinghouse.net>
>>
>>
>> I've been slowly tracking down a problem on one of my servers - after
>> prolonged periods of high disk activity, iowait goes to 100% and things
>> slow down to a crawl.
>>
>> I recall from previous experience, with a failing drive, that the drive
>> also tested fine - but seemed to have very high access delays as
>> compared to other drives (I can't remember what tool I used to measure
>> it) -- which led me to surmise that something, between the disk platter,
>> and higher level software, was exhibiting one of two failure modes:
>> a) very high delay, or,
>> b) required multiple retries, but ultimately came back with a proper
>> response
>> Either way, the performance of one drive dragged down the entire system.
>>      
> based on symptoms, your disk is frequently in deep recovery cycle. I.e. It tries for 5-20+ seconds to recover data.
>
> Fix is really to get enterprise drives which don't have this problem to begin with, after replacing drive... A patch is to run full media reads often to force remapping of hard-to-read blocks.
By "enterprise drives" are you suggesting drives with TLER?  As I've 
been reading through things, it seems like TLER is designed to avoid 
having disks drop out of RAID arrays, rather than what I'm looking for - 
i.e, have the drive drop out if it starts exhibiting high delays.

I notice that FreeBSD's GEOM raid drivers are tunable - there's a 
parameter "kern.geom.mirror.timeout" that lets you set a timeout 
condition for dropping a disk from a RAID array.  Is there an equivalent 
in md?

Miles


-- 

In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


