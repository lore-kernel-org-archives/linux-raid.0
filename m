From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: differnet UUIDs and no of spares :(
Date: Wed, 14 Jan 2009 17:50:31 -0500
Message-ID: <496E6C37.9030608@tmr.com>
References: <1231954002.17710.13.camel@brandy.snifter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1231954002.17710.13.camel@brandy.snifter.org>
Sender: linux-raid-owner@vger.kernel.org
To: Eamonn Hamilton <eamonn@snifter.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eamonn Hamilton wrote:
> Hi Guys,
>
> I'm looking at a server with a bunch of disks that had a raid 5 with two
> spares, however, one of the spares failed, the system then started
> rebuilding on the other and it crashed during the rebuild.
>
> I'm now left in the following situation :
>
>
> for a in a b c d e f g h i; do mdadm --examine --scan /dev/sd${a}; done
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>    spares=1
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>    spares=1
> ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>
>
> The system complains because of the different uuids, and refuses to
> recreate the array.
>
> Is it basically stuffed, or is there something I can do to recover the
> 2TB filesystem that's on there ?
>   

What can you tell us about how that happened? When (if ever) was it 
running, how was it created, etc, etc.

You could probably try some things like trying to start it read-only 
using --force, but don't do that yet, if you get it wrong you WILL be 
likely to lose data.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


