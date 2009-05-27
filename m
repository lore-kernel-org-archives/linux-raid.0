From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: forcing check of RAID1 arrays causes lockup
Date: Tue, 26 May 2009 20:33:30 -0500
Message-ID: <4A1C986A.7040403@gmail.com>
References: <20090526234523.GB14974@foobox.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090526234523.GB14974@foobox.homelinux.net>
Sender: linux-raid-owner@vger.kernel.org
To: kyle@foobox.homelinux.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

kyle@foobox.homelinux.net wrote:
> Greetings.
> 
> In the process of switching distributions on one of my machines, I've 
> run into a problem where forcing a check of the RAID arrays causes the 
> system to lock up.  I've got a bug open here 
> https://bugzilla.redhat.com/show_bug.cgi?id=501126 , but I'm hoping 
> someone here can help me track it down.
> 
> To add a little more to the last post on that bug, I've since installed 
> gentoo, and am running gentoo's patched 2.6.28-gentoo-r5 kernel (along 
> with mdadm 2.6.8), and I see the bug here.  I don't follow kernel 
> patches, and haven't looked too deeply into the distribution patches, 
> but diff isn't showing any changed code in drivers/{md,ata}/* .
> 
> And, to further describe "lock up", here's what happens in more detail:
> I write "check" to every md array's 'sync_action' file in /sys. 
> Within about a second, the system stops responding to user input, 
> doesn't update the mouse pointer, doesn't respond to pings.  
> I've tried to get in a run of dmesg in before the crash, and I've been 
> able to see the usual messages about checking arrays, but that's it.  
> Also, I once tried waiting for each array check to finish before 
> starting the check to the next array, and that seemed to work for a 
> while, but some time late in the several hour process the system locked 
> up again.  (It's possible that a cron job tried to start a check--no way 
> to know.)
> 
> Any ideas?
> 
> Thanks,
> Kyle Liddell

Not what you are going to want to hear but badly designed hardware.

On a machine I had with 4 disks (2 on a build-in via, 2 on other 
ports--either a built-in promise, or a sil pci card), when the 2 
build-in via sata ports got used heavily at the same times as any 
others--the machine became unstable, it caused issues with other 
non-disk pci cards doing flakey things, it caused the machine to also 
lockup (once the machine crashed, getting things to rebuild was almost 
impossible-MTBF was <5 minutes after a reboot), my end solution was to 
not use the via sata ports and then it became stable--not a great 
solution.   The via ports in my case were built into the mb and 
connected at pci66 ports, and the real pci bus was the standard 33mhz. 
   It appeared to me as designed the via chipsets (And think your 
chipset is pretty close to the one I was using) did not appear to deal 
with with high levels of traffic to several devices at once, and would 
become unstable.

Once I figured out the issue, I could duplicate it in under 5 minutes, 
and the only working solution was to not use the via ports.

My mb at the time was a Asus k8v se deluxe with a K8T800 chipset, and 
so long as it was not heavily used it was stable, but under heavy use 
it was junk.
