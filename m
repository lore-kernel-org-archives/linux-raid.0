From: David Greaves <david@dgreaves.com>
Subject: Re: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 22:33:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41339D1D.2040101@dgreaves.com>
References: <200408302014.i7UKEU306097@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408302014.i7UKEU306097@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Jonathan Baker-Bates' <jonathan@bakerbates.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think a better approach might be:

mdadm /dev/md1 -r /dev/hde3
dd if=/dev/hde3 of=/dev/null
check logs for nasty errors and only continue if there weren't any :)
mdadm /dev/md1 -a /dev/hde3

Having done this very thing this afternoon!!

If you have "some console messages about a bad block or something" then 
I'd make damn sure your disk is good before putting it back.
If you end up doing lots of retries during the resync and an error 
occurs on a remaining drive you'll be sorry!

In general a raid failure means you should suspect a disk failure.

I just wish Jeff G would get of his backside and make SMART work with 
libata - doesn't the man work on bank holidays? ;)

David


Guy wrote:

>No need to copy, that's what md does.
>
>Verify that the disk is not part of the array:
>mdadm -D /dev/md1
>
>I bet you will find the disk is there, but failed.
>So, raidhotremove it, then raidhotadd it.
>
>mdadm is the preferred tool.  The old raidtools are not supported.
>For details:
>man mdadm
>
>You may need to install mdadm.
>
>mdadm manage /dev/md1 -r /dev/hde3
>mdadm manage /dev/md1 -a /dev/hde3
>
>or short form:
>mdadm /dev/md1 -r /dev/hde3
>mdadm /dev/md1 -a /dev/hde3
>
>It should start to re-sync.  Monitor the status with:
>cat /proc/mdstat
>and/or
>mdadm -D /dev/md1
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jonathan Baker-Bates
>Sent: Monday, August 30, 2004 3:39 PM
>To: linux-raid@vger.kernel.org
>Subject: The right way to recover from md partition failure?
>
>I've been reading various FAQs and HOWTOs, but for some reason can't really
>get an answer to what I assume is a simple question about how best to get a
>failed md RAID 1 partition back into an array.
>
>After a power-outage, I see that cat /proc/mdstat shows:
>
>Personalities : [raid1]
>read_ahead 1024 sectors
>Event: 3
>md1 : active raid1 hdg3[1]
>      178787264 blocks [2/1] [_U]
>
>md0 : active raid1 hde2[0] hdg2[1]
>      2048192 blocks [2/2] [UU]
>
>md2 : active raid1 hde1[0] hdg1[1]
>      104320 blocks [2/2] [UU]
>
>unused devices: <none>
>
>So it looks like /dev/hde3 is down. I'm not sure exactly why this is, but
>there were some console messages about a bad block or something. So,
>assuming hdg3 is OK (which it seems to be) can I just do the following?
>
>Copy good partition to bad one:
>
>dd if=/dev/hdg3 of=/dev/hde3
>
>Add the resulting copy to the raid:
>
>raidhotadd /dev/md1 /dev/hde3
>
>fsck /dev/md1 to make sure all is well.
>
>Is there a better way?
>
>Jonathan
>
>
>
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

