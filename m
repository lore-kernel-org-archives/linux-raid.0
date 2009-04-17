From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 17 Apr 2009 20:40:14 +0200
Message-ID: <20090417183952.GA6090@lazy.lzy>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 17, 2009 at 02:17:47PM -0400, Doug Ledford wrote:
>> As you probably know, my preferred solution is to have all arrays
>> listed in /etc/mdadm.conf.  If it isn't in mdadm.conf, it doesn't get
>> assembled.   But I don't have a lot of company in this opinion.  Lots
>> of people want to have arrays assembled without them being in
>> mdadm.conf, and I'm trying to work with that.
>
> This appears to be the difference between a server setup and a desktop  
> setup.  Server admins want to list things and only have known actions  
> happen.  Desktop people want things to "just work".  I've had several  
> people tell me they thought the idea of mdadm.conf was completely out of 
> date and it should just go away entirely.  Not saying I agree, just  
> letting you know what I get.

My two cents on this.
One puzzling thing of mdadm.conf is how it is created.
In order to get it, either "mdadm --detail --scan" or
"mdadm --examine --scan" is required.
If I understand it correctly, the latter uses information
from the underlining disks directly.
Now, why this command should be run manually?
Can the "system" does it automatically on boot or on hotplug?

The problem is that when something is changed in the array,
the file needs to be recreated.
For example, this happened to me, after growing the array it
was not possibile anymore to restart it without rerunning
the "--examin --scan" thing.

It seems to me that the usage of mdadm.conf is a bit
fragile and looping.
To start the array I need mdadm.conf, to create it I
need the array... (maybe alread started).

So, in conclusion, I would support Doug on this, and
try to have a more sensible method to get the device
name out of the array.

Thanks,

bye,

-- 

piergiorgio
