From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 28 Oct 2007 14:37:44 +0100
Message-ID: <20071028133736.GA22861@percy.comedia.it>
References: <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <20071026091513.GB32550@percy.comedia.it> <1193426793.10336.302.camel@firewall.xsintricity.com> <20071027075054.GA12053@percy.comedia.it> <1193518050.10336.343.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193518050.10336.343.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 27, 2007 at 04:47:30PM -0400, Doug Ledford wrote:
>On Sat, 2007-10-27 at 09:50 +0200, Luca Berra wrote:
>> On Fri, Oct 26, 2007 at 03:26:33PM -0400, Doug Ledford wrote:
>> >On Fri, 2007-10-26 at 11:15 +0200, Luca Berra wrote:
>> >> On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
>> >> >The partition table is the single, (mostly) universally recognized
>> >> >arbiter of what possible data might be on the disk.  Having a partition
>> >> >table may not make mdadm recognize the md superblock any better, but it
>> >> >keeps all that other stuff from even trying to access data that it
>> >> >doesn't have a need to access and prevents random luck from turning your
>> >> >day bad.
>> >> on a pc maybe, but that is 20 years old design.
>> >
>> >So?  Unix is 35+ year old design, I suppose you want to switch to Vista
>> >then?
>> unix is a 35+ year old design that evolved in time, some ideas were
>> kept, some ditched.
>
>BSD disk labels are still in use, SunOS disk labels are still in use,
i am not a solaris expert, do they still use disk labels under vxvm?
oh, by the way, disklabels do not support the partition type attribute.

>partition tables are somewhat on the way out, but only because they are
>being replaced by the new EFI disk partitioning method.  The only place
>where partitionless devices is common is in dedicated raid boxes where
>the raid controller is the only thing that will *ever* see that disk.
well i am more used to other os (HP, AIX) where lvm is the common mean of
accessing disk devices

....

>> by default fdisk misalignes partition tables
>> and aligning them is more complex than just doing without.
>
>So.  You really need to take the time and to understand the alignment of
>the device because then and only then can you pass options to mke2fs to
yes and i am not the only person in the world doing that.

>> >Linux works properly with a partition table, so this is a specious
>> >statement.
>> It should also work properly without one.
>
>Most of the time it does.  But those times where it can fail, the
>failure is due to not taking the precautions necessary to prevent it:
>aka labeling disk usage via some sort of partition table/disklabel/etc.
I strongly disagree.
the failure is badly designed software.

>Did you stick your mmc card in there during the install of the OS?
My laptop has a built-in mmc slot, so i sometimes leave a card plugged
in. But the mmc thing was just an example, it is not that critical.
>> i don't count myself as a moron, what i am trying to say is that
>> partition tables are one way of organizing disk space, not the only one.
>
>Using whole disk devices isn't a means of organizing space.  It's a way
>to get a rather miniscule amount of space back by *not* organizing the
>space.
if i am using, say lvm to organize disk space, a partition table is
unnecessary to the organization, and it is natural not using them.

>This whole argument seems to boil down to you wanting to perfectly
>optimize your system for your use case which includes controlling the
>environment enough that you know it's safe to not partition your disks,
>where as I argue that although this works in controlled environments, it
>is known to have failure modes in other environments, and I would be
>totally remiss if I recommended to my customers that they should take
>the risk that you can ignore because of your controlled environment
>since I know a lot of my customers *don't* have a controlled environment
>such as you do.

The whole argument to me boils down to the fact that not having a partition
table on a device is possible, and software that do not consider this
eventuality is flawed, and recommnding to work-around flawed software is
just digging your head in the sand.
But i believe i did not convince you one ounce more than you convinced
me, so i'll quit this thread which is getting too far.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
