From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Wed, 03 Mar 2010 12:42:48 +0100
Message-ID: <4B8E4B38.9070702@shiftmail.org>
References: <yq1ocjemx46.fsf@sermon.lab.mkp.net>
 <20100225083936.07cd48ad@notabene.brown>
 <20100228080949.GA30574@maude.comedia.it>
 <20100302160100.621f9811@notabene.brown>
 <20100302073624.GA28827@maude.comedia.it>
 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
 <20100302110232.GA14131@maude.comedia.it> <4B8D5581.8070509@shiftmail.org>
 <20100302185216.GB2243@lazy.lzy> <4B8D9EDD.2080300@shiftmail.org>
 <20100303091314.GA3730@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100303091314.GA3730@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> I've a bunch of RAID-6 volumes, made of USB disks, i.e. using
> PATA<->USB bridges.
>   
Don't your bridges ever drop out or break?
What is the brand/model?
Years ago I broke alot of those, just by using the disks intensively. 
They probably kinda overheated then failed. They couldn't last 2 days on 
intense disk activity... They were chinese stuff bought on ebay though.

> This volumes are aggregated using LVM and, on top of that, there
> is a LUKS container.
>
> The raw read perfomance on the RAID-6 is, in the best case,
> around about 48MB/s, which is pretty good for USB, I guess it
> will be difficult to get more.
>   
48MB/sec can be good for 1 disk, but it's bad for many disks attached 
separately to USB ports...

> The raw read perfomance of the LVM volume is i~38MB/s.
> The raw read performance of the LUKS is ~28MB/s (actually
> maybe a bit less).
>   
Might your LVM or partition within it be not aligned, or you didn't set 
readahead?
http://www.beowulf.org/archive/2007-May/018359.html
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg10804.html
People using LVM on arrays giving hundreds of MB/sec see slowdowns of 
the order of percent
http://article.gmane.org/gmane.linux.raid/18302

>> LVM also does not merge requests AFAIR. (visible with mdstat -x 1)    
> BTW, what's that? I mean "mdstat -x 1"...  

I'm sorry I meant " iostat -x 1"

>> But me also I have never seen mismatches and the only raid-1's I
>> have are above LVM. (except /boot but that's almost never modified)
>>     
>
> Well, that's good, you confirmed my experience.
>
> I've also RAID-10 on LVM and never got mismatches, while the
> plain RAID-10 got sometimes.
>
>   
This fact needs further investigation methinks...
We could ask to the LVM people if LVM really copies the buffer.

Regards
A.
