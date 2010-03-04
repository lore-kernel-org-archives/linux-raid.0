From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: I am an idiot.
Date: Thu, 04 Mar 2010 12:01:50 +0000
Message-ID: <4B8FA12E.9000606@anonymous.org.uk>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Boag-Munroe <boagenator@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/03/2010 11:30, Alex Boag-Munroe wrote:
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
> --
> Alex Boag-Munroe
> 
> Lack of planning on your part does not constitute an emergency on mine.

OK, I was done pointing and laughing, until I saw your signature. Did 
you choose that on purpose or did Gmail pick it for you?

I'm afraid I can't help with your problem, except to say that I've a 
feeling you ought to be able to manually restart the half-reshaped array 
without the backup file, so the worst case ought to be that you might 
lose one backup file's worth of data. However, kernel and mdadm versions 
together with output of `mdadm --detail` of your md device and `mdadm 
--examine` of its constituent devices will help those more knowledgeable 
than me tell you what to do next. If you're lucky the boss, Neil Brown, 
will help but I imagine he's asleep right now since he lives in 
Australia and it's the middle of the night there.

Best of luck,

John.
