From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: creating RAID-1 - in which direction will the sync be made?
Date: Wed, 14 Jul 2010 15:48:39 +0200
Message-ID: <4C3DC037.1000802@wpkg.org>
References: <4C3D8BA7.2020500@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C3D8BA7.2020500@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14.07.2010 12:04, Tomasz Chmielewski wrote:
> In which direction will the devices be synchronized, if I create a new RAID-1 array with an external bitmap?
>
>
> Assuming I use this command line:
>
> mdadm --create /dev/md11 --level=1 --bitmap=/mnt/src/bitmap --raid-devices 2 /dev/storage/origin /dev/esata/copy
>
>
>
> Should I expect /dev/storage/origin being written to /dev/esata/copy?
>
> Or perhaps, /dev/esata/copy will be written onto /dev/storage/origin?
>
>
> I couldn't find it explained in the fine manual, so perhaps creating an array with a missing device:
>
> mdadm --create /dev/md11 --level=1 --bitmap=/mnt/src/bitmap --raid-devices 2 /dev/storage/origin missing
>
> and adding a second device later will be safer...

Looks like the first device in the command line will be synced onto the 
second.
However, I'd like someone to confirm this.


And that I should use "build" to sync the devices, otherwise, I'll write 
a superblock on each of them ;)


-- 
Tomasz Chmielewski
http://wpkg.org

