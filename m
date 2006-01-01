From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: hard drives with "variable"  device names - mdadm raid assembly options setup
Date: Sun, 01 Jan 2006 22:12:29 +1100
Message-ID: <87psncnqw2.fsf@rimspace.net>
References: <200512300908.19390.mlaks@verizon.net>
	<87d5jep027.fsf@rimspace.net> <dp52bc$nh8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk> writes:
> Daniel Pittman wrote:
>> Mitchell Laks <mlaks@verizon.net> writes:

[...]

>> Then, list your arrays:
>> ARRAY /dev/md2 level=raid1 num-devices=2
>> UUID=529d70fa:e5fe992b:ceb05593:bfcc6c25
>> That will cause mdadm to scan all those device entries (all the disks
>> and partitions) looking for an array with the right UUID, and assemble
>> it from all the components it finds.
>
> I am trying to do this with my 8 (currently only 7 since /dev/hdk is off
> line being replaced) disk raid5 array. mdadm --detail /dev/md0 gives :

[...]

>            UUID : 15bfec75:595ac793:0914f8ee:862effd8

[...]

> I am confused why there are only 4 UUIDs, when there are 7 devices
> listed...what should I put in my mdadm.conf file, which is currently 

You surely are confused, but there is only *one* UUID there, not four.

The UUID is presented as four blocks, with a ':' between them, by mdadm
for some reason beyond my understanding, but it is really just one
string.

Also, the UUID is per *MD* device, not per compontent (hda, sda) device.

So, you list the UUID for the array that mdadm told you as-is.

    Daniel

