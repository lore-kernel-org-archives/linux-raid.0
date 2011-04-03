From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Raid Checks
Date: Sun, 03 Apr 2011 09:48:47 +0100
Message-ID: <4D98346F.8090502@abpni.co.uk>
References: <4D983064.30808@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D983064.30808@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 03/04/11 09:31, Jonathan Tripathy wrote:
> Hi Everyone,
>
> I'm running CentOS 5.5 which a stock version of mdadm. I have 2 
> physical disks in a RAID1 setup. Each disk has 4 md partitions on it.
>
> I'm experiencing the issues associated with the raid-check script 
> every Sunday morning, where whatever is happening, a re-sync happens. 
> Doing a little reading around Google, I see that this is probably 
> caused by the mismatch_cnt being non-zero, which apparently is normal 
> for RAID1 devices. According to this bug:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=566828
>
> someone has made a patch for RedHat so that mismatch_cnt isn't checked 
> on RAID1 setups. However, since I don't use RedHat, and I don't really 
> want to compile mdadm from scratch, is there a workaround for this? I 
> don't want to just disable the raid-check script, as I think it does 
> some other important checks which are useful for RAID1.
>
> Any help would be appreciated
>
> Thanks
>
Seems like I'm a little confused...

To apply that patch, I don't need to re-compile, as it's just a script 
run by cron. However, looking at the script, it may not fix my "resync" 
issue which is happening every Sunday. Looks like that script just stops 
the mismatch warning email from being sent.

My main concern, is that during these resyncs, I loose redundancy, don't I?
