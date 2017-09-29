From: "John Stoffel" <john@stoffel.org>
Subject: Re: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 15:33:21 -0400
Message-ID: <22990.40961.77727.460505@quad.stoffel.home>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
        <22990.16096.295333.439814@quad.stoffel.home>
        <3760f13b-4f8f-4d9c-8382-96ee4f08d511@benshoshan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3760f13b-4f8f-4d9c-8382-96ee4f08d511@benshoshan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Ben-Shoshan <eli@benshoshan.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:

Eli> On 09/29/2017 08:38 AM, John Stoffel wrote:
>>>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:
>> 
Eli> I need to add another disk to my array (/dev/md128) when I accidentally
Eli> did an array resize to 9 with the following command:
>> 
Eli> First I add the disk to the array with the following:
>> 
Eli> mdadm --manage /dev/md128 --add /dev/sdl
>> 
Eli> This was a RAID6 with 8 devices. Instead of using --grow with
Eli> --raid-devices set to 9, I did the following:
>> 
Eli> mdadm --grow /dev/md128 --size 9
>> 
Eli> This happily returned without any errors so I went to go look at
Eli> /proc/mdstat and did not see a resize operation going. So I shook my
Eli> head and read the output of --grow --help and did the right thing which is:
>> 
Eli> mdadm --grow /dev/md128 --raid-devices=9
>> 
Eli> Right after that everything hit the fan. dmesg reported a lot of
Eli> filesystem errors. I quickly stopped all processes that were using this
Eli> device and unmounted the filesystems. I then, stupidly, decided to
Eli> reboot before looking around.
>> 
>> 
>> I think you *might* be able to fix this with just a simple:
>> 
>> mdadm --grow /dev/md128 --size max
>> 
>> And then try to scan for your LVM configuration, then fsck your volume
>> on there.  I hope you had backups.
>> 
>> And maybe there should be a warning when re-sizing raid array elements
>> without a --force option if going smaller than the current size?

Eli> I just tried that and got the following error:

Eli> mdadm: Cannot set device size in this type of array

Eli> Trying to go further down this path, I also tried to set the size 
Eli> explicitly with:

Eli> mdadm --grow /dev/md150 --size 1953383512

Eli> but got:

Eli> mdadm: Cannot set device size in this type of array

Eli> I am curious if my data is actually still there on disk.

Eli> What does the --size with --grow actually do?

It changes the size of each member of the array.  The man page
explains it, though not ... obviously.

Are you still running with the overlays?  That would explain why it
can't resize them bigger.  But I'm also behind on email today...

John
