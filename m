From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: Help!About MD on shared storage.
Date: Tue, 05 Aug 2003 14:42:12 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2F51C4.2050301@shaolinmicro.com>
References: <OF24C833E9.81D2D2DC-ON48256D78.001F7244@legend.com.cn> <1060018828.5102.78.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: sdake@mvista.com
Cc: hufh@Lenovo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>Note that the same thing can be done using a configuration file per node
>and using mdadm to only start the RAID volumes needed.  This is the
>methodology recommended by RAID maintainer, Neil Brown, however, I find
>it difficult to setup which is why I proposed the patch.  He could
>probably provide more info on that methodology or there is a discussion
>in the archives.
>
>If I ever get some time, I plan to implement shared access to the same
>RAID volume for usage in a clustered filesystem application such as GFS.
>
If it really happens, every writes to the RAID will need to be synced . 
Since fs assumes the underlying block device is synced instead of async 
like md . This has been an issue of using md on cluster environment 
which calling sync only sync fs->block buffers and md buffers are not 
gaurantee to be synced. I am not sure how much performnace drawback will 
cause if every write to md must be synced and wait for return for the 
underlying real block device. Any ideas?

David


