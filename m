From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Sat, 05 Oct 2002 17:42:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3D9F084F.1020200@karlsbakk.net>
References: <200210021516.46668.roy@karlsbakk.net> <200210031225.11283.roy@karlsbakk.net> <20021003114020.GD7350@unthought.net> <200210031513.28459.roy@karlsbakk.net> <20021003132349.GE7350@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jakob Oestergaard wrote:

>>>>But ... with persistent superblock - is it possible to fsckup the raid?
>>>>        
>>>>
>>>You're root, it is indeed possible  :)
>>>      
>>>
>>er - yes. I more meant like 'automagically'
>>    
>>
>
>It will only automagically screw up your arrays if you shuffle disks
>between machines (mix several RAID arrays from other systems in one
>system)  (you can of course move all your disks to one new machine, if
>it has none of it's original RAIDed disks left).
>
>Just don't mix disks with persistent superblocks from multiple machines
>into one single machine.  Unless you know exactly what you're doing.
>  
>
Could it be some kind of idea to 'sign' the disks with some hash out of 
hostname and  IP or something?

roy
