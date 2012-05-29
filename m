From: Oliver Schinagl <oliverlist@schinagl.nl>
Subject: Re: raid10 devices all marked as spares?!
Date: Tue, 29 May 2012 20:48:42 +0200
Message-ID: <4FC51A0A.6070700@schinagl.nl>
References: <4FC3E4FB.4010003@schinagl.nl> <20120529080736.03c62ae1@notabene.brown> <4FC3FFE7.6020606@schinagl.nl> <20120529090938.5af8a7ed@notabene.brown> <4FC518FB.4000408@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC518FB.4000408@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29-05-12 20:44, Oliver Schinagl wrote:
> <snip>
>>>> You can recover your data by re-creating the array.
>>>>
>>>>     mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
>>>>     -e 1.2  /dev/sda6 /dev/sdb6
>>>>
>>>> Check that I have that right - don't just assume :-)
>>> That looks very similar to what I used to create the array with, except
>>> the assume-clean part. I wonder however, would it not wiser to create
>>> the array using /dev/sda6 missing thus creating a degraded array?
>>> Atleast I'll still have the sdb6 which MAY contain the data also (since
>>> only sda6 'apparently' has wrong state?
>> That would be a suitable approach - arguably safer.  If you feel more
>> comfortable with it, then that is a strong reason to follow that course.
>
> I have tried that on sda6 but it cannot file a filesystem when trying 
> to mount md2. This of course is quite scary. I am now slightly 
> doubting if my chunksize is the same as before, 128k.
>
> I've used the following command.
> mdadm -C /dev/md2 -c 128 -l 10 -p o2 --assume-clean -e 1.2 -n 2 
> --name=opt /dev/sda6 missing
>
> Now I could try the same on sdb6 and hope that does work, but slightly 
> scared of loosing everything on that partition, it could be possible 
> of course that sdb6 is the partition that has everything in the 
> 'proper' order? I will try to losetup sdb6 with an offset and see if 
> that is mountable.
Also, I forgot to mention, the thing that is really strange, is that the 
data offset is somewhere extremely strange.

Data Offset : 262144 sectors

where sda4 and sdb5 (md0 and 1) both have 2048, which sounds common and 
sensible.

<snip>

Oliver
