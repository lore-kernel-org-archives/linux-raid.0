From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Failed RAID-5 with 4 disks
Date: Fri, 16 Sep 2005 12:52:03 -0700
Message-ID: <432B2263.5080805@h3c.com>
References: <20050726170329.GA30354@intoxicatedmind.net> <42E6B213.8020108@dtbb.net> <20050916113622.GI21856@intoxicatedmind.net> <432AFA95.3040709@h3c.com> <20050916190928.GJ21856@intoxicatedmind.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050916190928.GJ21856@intoxicatedmind.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Frank Blendinger wrote:
> On Fri, Sep 16, 2005 at 10:02:13AM -0700, Mike Hardy wrote:

>>Does an mdadm -E on the dd'd /dev/hde show that it has the superblock
>>and knows about the array? That would confirm that it has the data and
>>is ready to go.
> 
> 
> mdadm -E /dev/hde tells me: 
> mdadm: No super block found on /dev/hde (Expected magic a92b4efc, got
> 00000000)

This is bad - it appears that your dd either did not work or was not
complete or something, but /dev/hde does not contain a copy of an array
component.

You can not continue until you've got one of the two failed disks' data.

> OK, sounds good. I tried this:
> 
> $ mdadm --create --force --level 5 -n 4 /dev/md0 /dev/hdi /dev/hdk /dev/hde missing
> mdadm: /dev/hdi appears to be part of a raid array:
> level=5 devices=4 ctime=Mon Apr 18 21:05:23 2005
> mdadm: /dev/hdk appears to contain an ext2fs file system
> size=732595200K  mtime=Sun Jul 24 03:08:46 2005
> mdadm: /dev/hdk appears to be part of a raid array:
> level=5 devices=4 ctime=Mon Apr 18 21:05:23 2005
> Continue creating array? 
> 
> I'm not quite sure about the output, hdk gets listed twice (once false
> as an ext2) and hde (this is the dd'ed disk) not at all.
> Should i continue here?

Not sure why hdk gets listed twice, but its probably not a huge deal.
The missing hde is the big problem though. You don't have enough
components together yet

> Of course I don't want the second broken hard drive as spare. I just
> used it to dd its content to the new disk. I am going to get a new drive
> for the second failed one once I got the array back up and running
> (without redundancy).

The 'missing' slot and '-n 4' tells mdadm that you are creating a 4 disk
array, but one of the slots is empty at this point. The array will
created and initially run in degraded mode. When you add a disk to the
array later, it won't be a spare, it will give you the normal redundancy.

> Should a check for bad blocks on hdg and then repeat the dd to the new
> disk?

I'm not going to comment on specific disks, I don't really know your
complete situation. The process is the point though. If you have a disk
that failed, for any reason, you should run a long SMART test on it
('smartctl -t long <disk>'). If it has bad blocks, you should fix them.
If it has data on it that is not redundant you should try to copy it
elsewhere first. Once the disks pass the long SMART test, they're
capable of being used without problems in a raid array.

>>Alternatively you could forcibly assemble the array as it was with
>>Neil's new faulty-read-correction patch, and the blocks will probably
>>get auto-cleared.
> 
> 
> I am still using mdadm 1.9.0 (the package that came with Debian sarge).
> Would you suggest me to manually upgrade to a 2.0 version?

I'd get your data back first. Its clear you haven't used the tools much,
so I wouldn't throw an attempt at upgrading them into the mix. Getting
the data back is hard enough, even if the tools are old hat.

> I see, I completely misunderstood the manpage there.

Given this, and your questions about how to add the drives, and the
redundancy etc., the main thing I'd recommend is to practice this stuff
in a safe environment. If your data is important, and you plan on
running a raid for a while, it will really pay off in the long run, and
its so much more relaxing to run this stuff when you're confident in the
tools you have to use when problems crop up.

How to do that? I'd use loop devices. You create a number of files of
the same size, you export them as loopback-mounted devices, and build a
raid out of them. Open a second terminal so you can `watch cat
/proc/mdstat`. Open a third so you can `tail -f /var/log/messages`, then
start playing around with creating new arrays out of the loop files,
hot-removing, hot-adding etc. All in a safe way.

I wrote a script that facilitates this a while back and posted it to the
list: http://www.spinics.net/lists/raid/msg07564.html

You should be able to simulate what you need to do with your real disks
by setting up 4 loop devices and failing two, then attempting to recover.

-Mike
