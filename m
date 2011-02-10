From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 rebuild with only 2 spare devices
Date: Thu, 10 Feb 2011 20:07:34 +0000
Message-ID: <4D544586.4010506@anonymous.org.uk>
References: <4D542872.3090102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D542872.3090102@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Heilberg <theilberg42@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/02/2011 18:03, Thomas Heilberg wrote:
[...]
> root@backup-server:/media# mdadm -D /dev/md2
> /dev/md2:
> Version : 0.90
[...]
> Chunk Size : 64K
[...]
> I also tried to recreate the raid:
>
> root@backup-server:/media# mdadm -Cv /dev/md2 -n3 -l5 /dev/loop0
> /dev/loop1 /dev/loop2
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
[...]
> mdadm: Defaulting to version 1.2 metadata

Those loop devices are now trashed since you didn't re-create the array 
with exactly the parameters with which it was initially created. Your 
settings make me think the array was created with an older version of 
mdadm; the defaults for metadata version and chunk size changed a little 
while ago. Anyway, if you're trying again, you should specify -e 0.90 -c 
64. While you're at it, add --assume-clean to avoid any rebuild, which 
in your case may in fact destroy good data (though the array's parity 
would end up consistent). Or if as you noted in your other reply you're 
going to have to wait 15 hours before trying anything, maybe wait until 
The Boss[1] makes a more intelligent suggestion than I can; he usually 
posts at times that appear to be overnight to me but are presumably 
sensible times of day for him.

Cheers,

John.

[1] Neil Brown, who lives in Sydney where it's revoltingly early in the 
morning.

