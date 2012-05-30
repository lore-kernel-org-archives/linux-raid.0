From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: raid10 devices all marked as spares?!
Date: Wed, 30 May 2012 09:11:42 +0200
Message-ID: <4FC5C82E.9030106@schinagl.nl>
References: <4FC3E4FB.4010003@schinagl.nl> <20120529080736.03c62ae1@notabene.brown> <4FC3FFE7.6020606@schinagl.nl> <20120529090938.5af8a7ed@notabene.brown> <4FC518FB.4000408@schinagl.nl> <4FC51A0A.6070700@schinagl.nl> <20120530111405.53f7e68c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120530111405.53f7e68c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30-05-12 03:14, NeilBrown wrote:
> On Tue, 29 May 2012 20:48:42 +0200 Oliver Schinagl<oliverlist@schinagl.nl>
> wrote:
>
>> On 29-05-12 20:44, Oliver Schinagl wrote:
>>> <snip>
>>>>>> You can recover your data by re-creating the array.
>>>>>>
>>>>>>      mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
>>>>>>      -e 1.2  /dev/sda6 /dev/sdb6
>>>>>>
>>>>>> Check that I have that right - don't just assume :-)
>>>>> That looks very similar to what I used to create the array with, except
>>>>> the assume-clean part. I wonder however, would it not wiser to create
>>>>> the array using /dev/sda6 missing thus creating a degraded array?
>>>>> Atleast I'll still have the sdb6 which MAY contain the data also (since
>>>>> only sda6 'apparently' has wrong state?
>>>> That would be a suitable approach - arguably safer.  If you feel more
>>>> comfortable with it, then that is a strong reason to follow that course.
>>> I have tried that on sda6 but it cannot file a filesystem when trying
>>> to mount md2. This of course is quite scary. I am now slightly
>>> doubting if my chunksize is the same as before, 128k.
>>>
>>> I've used the following command.
>>> mdadm -C /dev/md2 -c 128 -l 10 -p o2 --assume-clean -e 1.2 -n 2
>>> --name=opt /dev/sda6 missing
>>>
>>> Now I could try the same on sdb6 and hope that does work, but slightly
>>> scared of loosing everything on that partition, it could be possible
>>> of course that sdb6 is the partition that has everything in the
>>> 'proper' order? I will try to losetup sdb6 with an offset and see if
>>> that is mountable.
>> Also, I forgot to mention, the thing that is really strange, is that the
>> data offset is somewhere extremely strange.
>>
>> Data Offset : 262144 sectors
> 128MB.
>
>> where sda4 and sdb5 (md0 and 1) both have 2048, which sounds common and
>> sensible.
> You'll need to use an older mdadm which uses the 2048 (1MB) offset.
> The next mdadm (3.3) will have a --data-offset option to make this easier to
> control.  For now you need 3.2.3 or earlier.
> That should make your filesystem accessible.  If it doesn't try a different
> chunk size. Maybe 64, maybe 512.
>
> NeilBrown
Ah! Well I got scared at one point and booted some ubuntu liveUSB which 
actually did have the 2048 offset. However I believe that the 128MB 
offset however broke the start of my ext4 partition. I've used testdisk, 
which does find an ext4 partition, but it is empty. All is not lost yet 
I suppose, as I can always try scanning for backup superblocks and use 
those to repair the ext4 partition? (Hadn't found any backup blocks yet)

Luckly I still have sdb6 which I will dd into an image onto a backup 
harddisk and see if I can make mdadm use that. *fingers crossed*

