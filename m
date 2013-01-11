From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 10:39:50 -0700
Message-ID: <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301110520.07128.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 11, 2013, at 5:20 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:

> On Thu Jan 10, 2013, Chris Murphy wrote:
>> On Jan 10, 2013, at 3:49 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
>>> A lot of it will be streaming. Some may end up being random read/writes.
>>> The test is just to gauge over all performance of the setup. 600MBs read
>>> is far more than I need, but having writes at 1/3 that seems odd to me.
>> 
>> Tell us how many disks there are, and what the chunk size is. It could be
>> too small if you have too few disks which results in a small full stripe
>> size for a video context. If you're using the default, it could be too big
>> and you're getting a lot of RWM. Stan, and others, can better answer this.
> 
> As stated earlier, its a 7x2TB array.

OK fair enough, and as asked earlier, what's the chunk size?

> 
>> Another thing to look at is if you're using XFS, what your mount options
>> are. Invariably with an array of this size you need to be mounting with
>> the inode64 option.
> 
> I'm not sure, but I think that's the default.

It's not but as Stan writes it may not be preferred for your application.

>> 
> 
> Plain old seagate baracudas, so not the best but at least they aren't greens.

They probably have a high ERC time out as all consumer disks do so you should also check /sys/block/sdX/device/timeout and make sure it's not significantly less than the drive. It may be possible for smartctl or hdparm to figure out what the drive ERC timeout is.

http://cgi.csc.liv.ac.uk/~greg/projects/erc/


> 
> 
> Debian seems to set up a weekly or monthly scrub, which I leave on due to 
> reading that same fact.

Unless there's a script to email you the results, you'll need to check it periodically. Or write a script that checks for reported errors and only sends an email if that's the case.

Chris Murphy

