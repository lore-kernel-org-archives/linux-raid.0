From: Carlos Knowlton <cknowlton@update.fsix.com>
Subject: Re: > 2TB ?
Date: Fri, 11 Feb 2005 07:41:50 -0600
Message-ID: <420CB61E.5030305@update.fsix.com>
References: <09d601c50fb1$b9c9df10$020a0a0a@musicroom>	 <l6vsd2-blf.ln1@news.it.uc3m.es> <62b0912f0502110132630b3ae4@mail.gmail.com>
Reply-To: cknowlton@science.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0502110132630b3ae4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:

>No email <null@hotmail.com> wrote:
>  
>
>>Forgive me as this is probably a silly question and one that has been
>>answered many times, I have tried to search for the answers but have
>>ended up more confused than when I started.  So thought maybe I could
>>ask the community to put me out of my misery
>>
>>Is there a version of MD that can create larger than 2TB raid sets?
>>    
>>
>
>I have a couple of terabyte software RAID 1+0 arrays under Linux.
>No size problems with MD as of yet.
>
>But the filesystems is a different affair, and I think this is where
>you should watch out.
>Linux filesystems seems to stink real bad when they span multiple
>terabytes, at least that's my personal experience.  I've tried both
>ext3 and reiserfs.  Even simple operations such as deleting files
>suddenly take on the order of 10-20 minutes.
>  
>
I'm running some 3TB software arrays (12 * 250GB RAID5) with no 
trouble.  I've opted for XFS over ext3 or reiserfs, and I see no trouble 
in accessing or deleting files.  However, my Windows clients can't see 
the volume unless I tell them that it is less than 2TB ("max disk size" 
param in smb.conf).

>I haven't got a ready explanation for why ext3 and reiser can't handle
>TB sizes, but I'd definately advice you against a multi-TB setup using
>Linux (at least until you find someone who has a working setup..)
>  
>
I would tend to agree, unless you use a 2.6 kernel, and XFS, then it's 
not a problem.  Well, as far a software RAID goes anyway - I wish it 
handled trivial media errors more gracefully (ie, without dropping 
disks).  You should always back-up your data.

-CK
