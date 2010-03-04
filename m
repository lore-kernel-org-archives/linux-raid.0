From: Asdo <asdo@shiftmail.org>
Subject: Re: I am an idiot.
Date: Thu, 04 Mar 2010 13:25:08 +0100
Message-ID: <4B8FA6A4.3040309@shiftmail.org>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Boag-Munroe <boagenator@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alex Boag-Munroe wrote:
> Hi guys...
>
> Yes I am an idiot.  I was changing the chunk size of my RAID5 array
> last night from 64kb to 256kb and left it running overnight.  During
> the night we had a power outage.
>
> This is where the idiot part comes in.  The backup file is on a
> filesystem that's part of the RAID5 array, so obviously I am unable to
> start it.  I completely forgot the filesystem I specified for
> --backup-file was part of the same array.
>
> Once you're all done pointing and laughing, can you let me know if I
> am totally screwed?  I've a lot of data here that I -really- don't
> want to lose...
>
> Please help..
>
> Idiot.
>   

Firstly I will say that I have never faced this situation, so please 
wait for someone more knowledgeable to reply before trying.

Supposing the resync cannot be continued after a power failure (which I 
am not sure)...

My idea is that the reshape progresses linearly so one of the two 
filesystems (either the original one or backup) should be accessible. If 
the power failed when the reshape was within the first filesystem, the 
second filesystem should be somehow accessible, if it failed when the 
reshape was within the second filesystem, the first filesystem should be 
somehow accessible.

In this situation I guess you need to go to the hard route: you will 
probably need to recreate the array with all the drives specified 
exactly in the same order, using all the original options (you can get 
info from every drive with mdadm --examine /dev/sdXY), and the chunksize 
either set at 64k or at 256k (you try both), and specifying 
--assume-clean so that it does not start to resync, and then set it 
--readonly before doing anything else. Then you will probably be able to 
do some experiments try mounting one of the two filesystems.

Thinking again, I guess there is a situation which will prevent you to 
see both filesystems... this is the case if 64kb prevents you to see the 
good filesystem and 256k prevents you to see the LVM metadata :-( You 
use LVM right? In this case you might need to "find" your filesystem by 
mounting the device with progressively increasing offsets from the 
beginning, without the help of LVM. And this will work only if your good 
partition in LVM was contiguous (LVM allows holes).

Anyway, wait other replies.

Good luck

Asdo


