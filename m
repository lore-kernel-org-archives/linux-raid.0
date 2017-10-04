From: "John Stoffel" <john@stoffel.org>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 14:03:00 -0400
Message-ID: <22997.8788.365049.748860@quad.stoffel.home>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
        <871sn78pzt.fsf@notabene.neil.brown.name>
        <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
        <874ls0s7un.fsf@notabene.neil.brown.name>
        <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
        <87lgkr3fgj.fsf@notabene.neil.brown.name>
        <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
        <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
        <20171004173059.GB3181@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171004173059.GB3181@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Piergiorgio" == Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:

Piergiorgio> On Wed, Oct 04, 2017 at 01:23:02PM +0200, Artur Paszkiewicz wrote:
>> On 10/04/2017 01:02 PM, Artur Paszkiewicz wrote:
>> > Applications like mdadm can use this to hide/unhide their component
>> > devices.
>> 
>> And here is an example patch for mdadm. It adds options to manually hide
>> or unhide the component devices:
>> 
>> mdadm --hide-components /dev/md0
>> mdadm --unhide-components /dev/md0

Piergiorgio> This seems to me already quite sensible.

>> 
>> And an option for mdadm.conf that automatically hides the array's member
>> disks when assembling and when new disks are added:
>> 
>> ARRAY /dev/md/0  metadata=1.2 UUID=c2c4f8c6:cd775924:9cb2cc62:88fa45bd
>> name=linux-ns31:0 hide-components=yes
>> 
>> Hidden disks (by mdadm --hide-components or by config) should unhide
>> when the array is stopped or disks are removed. It only works for whole
>> devices, not partitions.

Piergiorgio> Well, this, on the other hands, it makes it not really
Piergiorgio> useful.

Yeah, this totally doesn't work or scale.  If you're using partitions
(why would you not?) as raid devices, even on a whole disk, you now
limit yourself.  

