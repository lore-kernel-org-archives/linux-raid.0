From: "Marc L. de Bruin" <marc@debruin.org>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from
 2.6.11
Date: Mon, 10 Apr 2006 20:03:08 +0200
Message-ID: <443A9DDC.10601@debruin.org>
References: <4438FFA9.4030907@debruin.org> <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org> <443A0F3A.90104@debruin.org> <Pine.LNX.4.64.0604100843370.29514@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0604100843370.29514@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> On Mon, 10 Apr 2006, Marc L. de Bruin wrote:
> 
>> dean gaudet wrote:
>>
>>> initramfs-tools generates an "mdrun /dev" which starts all the raids it can
>>> find... but does not include the mdadm.conf in the initrd so i'm not sure it
>>> will necessarily start them in the right minor devices.  try doing an "mdadm
>>> --examine /dev/xxx" on some of your partitions to see if the "preferred
>>> minor" is what you expect it to be...
>>>  
>> blah@frodo:~# sudo mdadm --examine /dev/md[01234]
> 
> try running it on /dev/sda1 or whatever the component devices are for your 
> array... not on the array devices.
> 
> -dean

Briljant, that turned out to work.

However, all "preferred minor"s are correct, meaning that the output is in 
sync with what I expected it to be from /etc/mdadm/mdadm.conf.

Any other ideas? Just adding /etc/mdadm/mdadm.conf to the initrd does not 
seem to work, since mdrun seems to ignore it?!

Marc.
