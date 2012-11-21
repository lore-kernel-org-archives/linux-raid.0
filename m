From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mdadm: use static major/minor numbers.
Date: Wed, 21 Nov 2012 12:26:00 +0000
Message-ID: <50ACC858.6030105@mpstor.com>
References: <50AB7964.60002@mpstor.com> <20121121081622.162d6f08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121081622.162d6f08@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/11/12 21:16, NeilBrown wrote:
> On Tue, 20 Nov 2012 12:36:52 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:
>
>> Hi!
>>
>> I recently updated mdadm-2.6.9 to mdadm-3.2.6 on a system (own busybox
>> based distro) that had its kernel version updated from 2.6.35 to 3.4.
>>
>> Everything works well apart from a feature I used that I seem to be
>> unable to reactivate:
>>
>> In the past, to ensure knowing the number of possible RAID devices that
>> could be created on the system, I used static major:minor mappings by
>> building the /dev/md/dXX and /dev/md/dXXpXX entries (with major 254, and
>> three minors for each device for 3 partitions), allowing me to be
>> certain that 64 RAID devices could be created at all times.
>>
>> When creating an array, the /dev/md/dXX and dXXpXX devices "nodes" would
>> be used (not recreated) and the major/minor number these devices point
>> to would be used for the actual MD block device.
>>
>> This was a very handy feature. With the latest mdadm, I simply cannot do
>> that, as creating a /dev/md/dXX will in fact remove that device file and
>> symlink it to /dev/md_dXX. I then created /dev/md_dXX devices prior to
>> creating an array, and got the following error message: "mdadm:
>> /dev/md_d3 exists but looks wrong, please fix".
>>
>> Looking through the source I can see that mdadm basically verifies if
>> the file's major/minor matches the one that it had planned for the
>> device, which in this case doesn't.
>>
>> Is there any way to work around that? Or in fact, I don't actually
>> *need* to use static major/minor numbers, but I need to know in advance
>> how many RAIDs I'll be able to create provided I'll always use 2
>> partitions for them and can provide the -amdp2 argument to mdadm to make
>> sure that only 2 partitions devices nodes are created.
>>
>> Is there a way to know the maximum number of RAIDs that can be created,
>> provided that nothing else uses major 9 and 254?
>>
>> Thank you very much in advance for your help!
> I don't really understand what your problem is.
>
> mdadm should create any devices it needs - unless it detects udev, in which
> case it leaves the device creation to udev.
>
> So simply don't create any md devices in /dev and let mdadm do whatever is
> required.
> Does that approach not suit your needs?  If not, why not?
>
> NeilBrown
Hi Neil,

mdadm creates the devices it needs quite well (there is no udev on this 
system), but how can I tell how many maximum RAID devices mdadm will be 
able to create before running out of major/minors, since their 
allocation is done on the fly?

Will mdadm use all of "md" registered major (9) minor numbers (9:0-254)? 
Will it also use the "mdp" registered ones (254) when running out?

I need to know how many MD devices I'll be able to create in advance on 
that system. Creating the devices beforehand helped with that, since I 
had md_d0 254:0 up to md_d127 254:252, I knew that I could create a 
maximum of 128 devices.

What's the maximum number of MD devices that can be created on a 
udev-less system provided we specify 2 partitions in mdadm --create?

Thank you very much in advance for your help.

Regards,
Ben.
