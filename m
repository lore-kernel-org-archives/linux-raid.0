From: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Subject: Re: Strangeness when booting raid1: md5 already running?
Date: Tue, 22 Mar 2005 11:24:27 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0503221119150.26421@gatemaster.ivimey.org>
References: <1111407978.757.7.camel@filestore.ivimey.org>
 <16959.19685.520138.180516@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
In-Reply-To: <16959.19685.520138.180516@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Mar 2005, Neil Brown wrote:

> On Monday March 21, Ruth.Ivimey-Cook@ivimey.org wrote:
> ...repeated several times....
>> md: export_rdev(hda9)
>> md: ... autorun DONE.
>> EXT3-fs: INFO: recovery required on readonly filesystem.
>> EXT3-fs: write access will be enabled during recovery.
>> EXT3-fs: recovery complete.
>>
>> Now this was the first time the string "md5" appears in the log. And
>> indeed, it appears that hda9 has been kicked out of the array:
>
> So was md5 actually running (what did /proc/mdstat show? What about
> mdadm -D /dev/md5?).

mdstat and mdadm both report that md5 is running degraded - with hdc9 and hda9 
removed.

> which wasn't part of an array but couldn't be added to one.  Nothing
> particularly interesting.

Ok. I'll just re-add the drive and see what happens.

Thanks

Ruth

-- 
Ruth Ivimey-Cook
Software engineer and technical writer.
