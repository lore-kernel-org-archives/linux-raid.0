From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Bugreport ddf rebuild problems
Date: Mon, 05 Aug 2013 18:55:47 +0200
Message-ID: <51FFD913.1090301@gmail.com>
References: <51FAB74B.4030200@gmail.com>	<51FAB282.6040303@arcor.de> <CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com> <51FACF7C.50400@arcor.de> <51FADCA5.1080801@arcor.de> <51FAE319.6030604@arcor.de> <51FCD0BB.1040402@gmail.com> <51FE234A.4060808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FE234A.4060808@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil/Martin,

I have pulled the latest git version (up and including Makefile: check 
that 'run' directory exists.).
It works, except for the last error I noticed, see below.

Regards,

Albert


On 08/04/2013 11:47 AM, Albert Pauw wrote:
> Hi Martin,
>
> I noticed another problem, with or without your patch, the problem 
> occurs:
>
> Zeroed the superblocks (just in case):
> mdadm --zero-superblock /dev/loop[1-6]
>
> Created the container:
> mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]
>
> Created an md device in the container, it used /dev/loop4 and 
> /dev/loop5, rebuild and finished
> mdadm -CR /dev/md0 -l raid1 -n 2 /dev/md127
>
> I fail one of the disks, it rebuild with one of the available unused 
> disks in the container:
> mdadm -f /dev/md0 /dev/loop4
>
> I add another md device.
> mdadm -CR /dev/md1 -l raid5 -n 3 /dev/md127
>
> This last one is the odd bit, it is build using the previously failed 
> disk. Looks like the container is not aware that /dev/loop4 has failed,
> en reuses it. Which is wrong. So the failed status is not kept.
>
> Regards,
>
> Albert
>



