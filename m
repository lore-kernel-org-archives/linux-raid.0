From: David Greaves <david@dgreaves.com>
Subject: Re: Help with Failed array
Date: Sun, 12 Jul 2009 12:47:38 +0100
Message-ID: <4A59CD5A.2070406@dgreaves.com>
References: <dd404eb00907110001n177f9fabpb394aac706d3e90@mail.gmail.com> <dd404eb00907110046k2bda785fy204c0d23075bda24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dd404eb00907110046k2bda785fy204c0d23075bda24@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Kenyon <zhadnost@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Kenyon wrote:
> My server at home operates a 4 disk software RAID 5 array which is
> normally mounted at /.
> 
> At the moment I am using mdadm v2.6.7.2 (I don't know which version
> built the array).
Also kernel version.


> One of the disks appeared to have developed a fault, an I/O error
> would be produced and the array would rebuild to try and mao round it,
> and once it had finished there'd be another I/O error and it would
> start again.
> 
> I marked the drive as faulty, removed it from the array, replaced it
> with a nother drive, replicated the partition map and added it to the
> array.
> 
> As expected the drive started being built.
Good

> I'm not sure if it had finished by this point, but another disk
> produced an I/O error which broke the array.
During the rebuild? That doesn't make sense since below it's showing 'clean'.
Are you sure the rebuild didn't finish?

If not then you may need expert support (probably from Neil on monday).
I suggest digging out the logs to see.

> Now I'm trying to recover any data I can from it.
Normally with the data you describe below the /dev/sd[abd]1 partitions would
happily create a degraded array.
However if you are sure sdb is broken then I'd wait.

> When I first try to assemble the array, this message appears in kernel messages.
command?

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
