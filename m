From: Gordon Henderson <gordon@drogon.net>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 10:29:33 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0705151019070.30502@lion.drogon.net>
References: <4649760A.1060805@wpkg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4649760A.1060805@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 May 2007, Tomasz Chmielewski wrote:

> I have a RAID-10 setup of four 400 GB HDDs. As the data grows by several GBs 
> a day, I want to migrate it somehow to RAID-5 on separate disks in a separate 
> machine.
>
> Which would be easy, if I didn't have to do it online, without stopping any 
> services.
>
>
> M1 - machine 1, RAID-10
> M2 - machine 2, RAID-5
>
>
> My first idea was to copy the data with rsync two or three times (because the 
> files change, I would stop the services for the last run) - which turned out 
> to be totally unrealistic - I started rsync process two days ago, and it 
> still calculates files to be copied (over 100 million files, with hardlinks 
> etc.).

I have recent experience of copying up to 1TB parititions to offsite 
backup servers via rsync (and a 10Mb line), and it can be done.

You do need a recent version of rsync and a lot of memory in both servers. 
I'm really surprised it takes days to do this on your server - although 
maybe the source server really is busy? I was doing in over about 2-3 
hours on the servers I was working with. (Several "smaller" ones backing 
up to one 6TB box) The first copy is always the longest, but if after 2 
days it's not even started to copy the files, then it's gonig to be slow. 
Lots of hardlinks will really slow things down though (and cause memory to 
grow), as it has to find out each filename linked to each file. I've not 
looked too closely into it, but I suspect it's as efficient as a bubble 
sort due to what it has to do. Lots of memory will help if it can keep 
everything cached as well as letting rsync build up it's data without 
swapping.

> Ideas how to synchronize the contents of two devices (device1 -> device2)?

Look into the speed of the processors too - rsync will use ssh by default 
- which will incur a CPU overheard to do the encryption. If encryption 
isn't an issue, then look into using rsh rather than ssh. (Although making 
a modern system let you login as root with rsh without a password is 
sometimes "challenging" :)

Another solution might be to use tar, but this is good for snapshotting 
rather than applying incremental updates. something like

    tar cf - /bigVolume | rsh remoteServer -c 'cd target ; tar xfB -'

or something. (it's years since I've done it this way, so check!) You 
might want to set blocking factors which might improve network throughput. 
(And you never know, a modern tar might be able to do incremental changes)

Gordon
