From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Why does the md/raid subsystem does not remap bad sectors in
 a raid   array?
Date: Sun, 23 Nov 2008 08:34:20 +0400
Message-ID: <4928DD4C.4020301@wasp.net.au>
References: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan> <4928B580.5040800@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4928B580.5040800@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Robert Hancock wrote:
>> The controller does not drop the drive from the array when it hits an 
>> error, the 3ware card "takes care of it" and the user need not worry 
>> about it, whereas with md/raid every time it hits a bad sector, it 
>> breaks the raid and it goes degraded, is this correct?  Will/can 
>> something like what 3ware does be possible in a sw-raid based 
>> configuration or is a HW raid card required?
> 
> Presumably all it's doing is writing that sector's contents back from 
> the other drive(s) in the array when the read error is detected, this is 
> something that software could do just as well. Drives only remap bad 
> sectors when they are written over, as a read failure doesn't 
> necessarily mean that the sector is entirely unreadable, but could be 
> due to environmental factors such as high temperature, vibration, etc.
> 
> Just rewriting the sector seems a bit questionable though, as if a drive 
> in your array is growing read errors that's not really a good thing..

md has done this for a while now though. If it encounters a read error in the array it will make an 
attempt to write the reconstructed data back to that disk attempting to force a reallocation. I've 
seen it work quite well here on disks that have the occasional grown defect.

It's certainly _much_ nicer than having the disk booted from the array on a single read error.

If the disk is haemorrhaging sectors then you will find out about it sooner or later through other 
means.

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
