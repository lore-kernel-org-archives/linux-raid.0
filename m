From: Spencer Tuttle <rodeojones@fastmail.fm>
Subject: Re: Autostart RAID1 on boot
Date: Tue, 15 Nov 2005 16:05:37 -0700
Message-ID: <437A69C1.6070105@fastmail.fm>
References: <437A11F3.90204@fastmail.fm> <20051115170603.GA32673@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051115170603.GA32673@jose.lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:
> On Tue, Nov 15, 2005 at 09:50:59AM -0700, Spencer Tuttle wrote:
> 
>>What do I have to do to autostart this array on boot?
> 
> 
> Read Documentation/md.txt in your kernel source.  Has lots of cool
> options for setting up kernel assembly on boot.
> 
> If you have a reasonably recent array with persistent superblocks,
> something like this will do you fine for your root partition:
> 	md=0,/dev/hda1,/dev/hdc1
> 
> If you use initrd/early userspace stuff then you can also drop mdadm
> in your initrd image and get it to start the array.  If you're using
> Debian, it's mkinitrd scripts automatically support that if you get
> things setup properly.
> 

That was it I was appending "md=d0,hda,hdb".

I changed to to "md=d0,/dev/hda,/dev/hdb" and It starting working like a 
champ.

Thank You
