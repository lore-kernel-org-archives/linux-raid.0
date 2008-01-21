From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: mdadm error when trying to replace a failed drive in RAID5 array
Date: Mon, 21 Jan 2008 02:38:01 -0800
Message-ID: <D5500219-7AD7-426A-8D45-C5D2B731EBCB@develooper.com>
References: <017101c85baa$6a9c3850$0603a8c0@meanmachine>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <017101c85baa$6a9c3850$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: 'Neil Brown' <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 20, 2008, at 1:21 PM, Steve Fairbairn wrote:

> So the device I was trying to add was about 22 blocks too small.   
> Taking
> Neils suggestion and looking at /proc/partitions showed this up
> incredibly quickly.

Always leave a little space in the end; it makes sure you don't run  
into that particular problem when you replace disks and the end of the  
disk is often significantly slower anyway.

 From before the write-intent bitmap stuff I have/had a habit of  
creating separate raids on relatively small partitions (joined  
together by LVM).  I'd just pick a fixed size (on 500GB disks I'd use  
90GB per partition for example) and create however many partitions  
would fit like that and leave the end for scratch space /  
experiments / whatever.


  - ask

-- 
http://develooper.com/ - http://askask.com/


