From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to delay mdadm assembly until all component drives are
 recognized/ready?
Date: Tue, 16 May 2017 18:49:46 -0500
Message-ID: <4f620f0b-c019-994d-bb8a-549fa92195af@gmail.com>
References: <243ef080-c32f-f423-3a98-af70194f994b@gmail.com>
 <877f1gmr49.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f1gmr49.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/16/2017 04:25 PM, NeilBrown wrote:
> On Tue, May 09 2017, Ram Ramesh wrote:
>
>> Today, I noticed that my RAID6 md0 was assembled in degraded state with
>> two drives in failed state after a pm-suspend and restart. Both of these
>> drives were attached toSAS9211-8I controller. The other drives are
>> attached to motherboard. I have not had this on a normal boot/reboot.
>> Also, in this particular case, mythtv recording was going on when
>> suspended and therefore as soon as resumed that used this md0.
>>
>> Upon inspection, it appears (I am not sure here) that mdadm assembled
>> the array even before the drives were ready to be used. All I had to do
>> was to remove and re-add them to bring the array back to "good" state. I
>> am wondering if there is a way to tell mdadm to wait for all drives to
>> be ready before assembling. Also, if there is something that I can add
>> to resume scripts that will help, please let me know.
>>
>> Kernel: Linux zym 3.13.0-106-generic #153-Ubuntu SMP
>> mdadm - v3.2.5 - 18th May 2012
>>
>> Failed drives are HGST NAS and WD Gold with less than a year of usage.
>> So I doubt they are bad drives by any means.
> This is a question that needs to be addressed by your distro.  mdadm
> just does what it is told to do by init/udev/systemd scripts.
>
> The preferred way for array startup to happen is that when udev
> discovers a new device, "mdadm --incremental $DEV" is run, and mdadm
> includes the device into an array as appropriate.  mdadm will not
> normally activate the array until all expected devices have appeared.
> After some timeout "mdadm -IRs" or "mdadm --run /dev/mdXX" can be run to
> start the array even though it is degraded.
>
> The udev-* scripts and systemd/* unit files provided with current
> upstream mdadm do this, with a 30 second timeout.
> If a given distro doesn't use these scripts, you need to take it up
> with them.
>
> NeilBrown
Neil,

   Thanks. I was hoping that there is something that I can add to 
mdadm.conf that will make this work. That is why I checked here, as my 
mdadm expertise is liminited. Anyway, it appears that the problem is due 
ext4lazyinit which accesses md instantaneously after resume. I will take 
this up with the distro folks. My machine badly needs an upgrade. I 
think it is time

Ramesh
