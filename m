From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: mdadm message (auto-read-only) on "/dev/md1" = swap file system
Date: Thu, 11 Jun 2009 03:30:00 +1000
Message-ID: <D081A9AE-6E07-4568-880A-2CC8A47947C1@crc.id.au>
References: <2b91784d0906101010l409c38d2m8d0e7401c454307f@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2b91784d0906101010l409c38d2m8d0e7401c454307f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/2009, at 3:10 AM, Ing. Jair wrote:

> Dear Linux -raid community masters,
>
>
> I have a quick question regarding something i noticed on my first time
> mdadm linux raid configuration server:
>
>
> Current System:
>
> Debian Lenny 5.0
> Two 250GB hard drives identical brand, size, model, speed, etc... they
> are the same.
> 3GB memory ram
> 1 AMD athlon 2500 CPU
>
> Here I am pasting an example of another machine I configure with the
> same result notice the "(auto-read-only)" message on the swap file
> system:
>
>
> md2 : active raid1 hde3[0] hdg3[1]
>      153557184 blocks [2/2] [UU]
>
> md1 : active (auto-read-only) raid1 hde2[0] hdg2[1]
>      2634560 blocks [2/2] [UU]
>
>
>
> md0 : active raid1 hde1[0] hdg1[1]
>      96320 blocks [2/2] [UU]
>
> unused devices: <none>
>
>
> My question for this is:
>
> 1. Is this the way suppose to work on the device md1 = swap  
> filesystem raid?

I believe the array will stay read-only until the first write is  
performed - at which time the array will automatically switch to read/ 
write.

> 2. If this is normal where can I find documentation about the
> different "messages" displayed on the command "cat /proc/mdstat"?
>
> 3. If this is a bug, is there a work around and what will happen if
> this continue to appear?
>
> 4. I ran the command mdadm -w /dev/md1 and the message disappear, but
> after rebooting the system came back up.
>
> I appreciate any information or document, links, ideas you can  
> provide to me.


The following bug report shows this behaviour, and the reply shows  
this behaviour as 'not a bug'.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=464560

I can't find any more solid references to this however... This being  
said, logic says that if this is correct, the array would only go read/ 
write when something writes to your swap space...

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
