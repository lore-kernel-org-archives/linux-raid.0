From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Fri, 19 Oct 2012 10:11:44 +1100
Message-ID: <50808CB0.8020902@websitemanagers.com.au>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com> <507F7428.6030003@websitemanagers.com.au> <CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jivko Sabev <jsabev@nicmus.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/10/12 02:19, Jivko Sabev wrote:
> Hi,
> 
> The mdadm.conf in the initrd image contains the correct devices. I.e.
> the contents of mdadm.conf in initrd are the output of
> 
> mdadm --detail --scan
> 
> ARRAY /dev/md0 metadata=1.2 name=mercury:0
> UUID=60ea870e:029dcf99:eaae356e:f1c12085
> ARRAY /dev/md1 metadata=1.2 name=mercury:1
> UUID=d89a52ed:0247f2e8:5edf5d09:21e7fa48
> 
> Here are the contents of /proc/mdstat from the initrd shell before
> reassembling the array.
> 
> md1 : inactive sde1[2](S)
>       976639672 blocks super 1.2
> 
> md0 : active linear sdb1[0] sdc1[1]
>       976770537 blocks super 1.2 0k rounding
> 
> unused devices: <none>
> 
> It just seems to me that it is not possible to mix md devices and sata
> devices for new arrays.

I know it is possible because I have done this before ...

Try adding the device names to the mdadm.conf....

An alternative would be to create a partition table on /dev/md0 of type
fd, this way it should be handled properly by the rest of the MD auto
assemble code.

The other option might be to use a different superblock version between
the two arrays...

Other than that, I'm not too sure, maybe someone else could comment?
Perhaps you could provide the logs generated during bootup in relation
to the MD discovery etc

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
