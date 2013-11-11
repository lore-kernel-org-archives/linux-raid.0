From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 10:29:17 +0200
Message-ID: <91233A88-BE7C-4305-A3C1-DE3120F4EA8F@gmail.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com> <527FE89A.4010608@hardwarefreak.com> <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com> <52805251.2010102@hardwarefreak.com> <6DC2162E-B592-4183-B645-71BC8AC21C76@gmail.com> <528090CE.4040504@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528090CE.4040504@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 11, 2013, at 10:09 AM, David Brown <david.brown@hesbynett.no> wrote:

>> That, and I also read on my distro's wiki that 'check' will pick up
>> where it was interrupted automatically in those cases when a system
>> is rebooted before 'check' is complete. Well, apparently it does not
>> work that way because I was only some 4% into 'check' yesterday
>> evening, and after resume from sleep mdstat does not show that
>> 'check' is running. So, does the distro's wiki contain erroneous
>> information?
>> 
> 
> I can't say anything about that other than general points about "sleep"
> being a half-way house between rebooting and running.  It does not
> surprise me that you get issues with things not restarting after a sleep
> and wakeup.

Tried to echo 'check' but it started from the very beginning. So, the status of the 'check' got reset or something like that.

> As far as I understand your posts, you have a laptop that you use as a
> normal machine and also as a server.  Presumably you are connected to
> mains power rather than a battery.  Why not just let the thing run
> overnight?  It's a laptop - it's low power already.  As long as things
> like the display turn off (and perhaps the disks too, after some period
> without use), the power used will be tiny.  So keep it turned on, or
> turn it off - then you don't have any sleep problems.
> 
> I don't think you mentioned what distro you are using (I might have
> missed it), which makes it difficult to guess what the "distro's wiki" says.

Yes, it's a what I call a hybrid desktop/server laptop. It used to be my Linux workstation years ago, slowly it turned into more of a server type host on home LAN. I still run X and GNOME and connect via VNC to manage VirtualBox in GUI and what not, but 99% of the time it is more like a server. I enjoy, and frankly need, ability to enter sleep and resume on this machine because it sits on my table less then 2 meters away from my bed, and even when idle the fans noise drives me nuts. So, it is absolutely not an option to keep it running at night. There's also no alternative where to put it, so sleep mode has been hands down the best solution for me. Powering it off completely is also not an option because one of the issues is that this laptop has maximum amount of RAM installed, and that so
 mehow causes its BIOS to run full memory test on each start, so it takes about 1.5-2 minutes (maybe more, I never measured but it kind gets on your nerves when you need to reboot) -- compare that to ~ 30 seconds resume from sleep with all the stuff restored at the state it was left in. It is damn convenient and is totally worth a little work on pm-utils hooks to get things rolling smoothly. Well, at least totally justified for me, that is ;D

I run Arch Linux on this laptop, and the system has not been updated since mid 2012. Deliberately, I like it that way lol The Arch Linux wiki has this note:

> Note: If the system is rebooted after a partial scrub has been suspended, the scrub will start over.

https://wiki.archlinux.org/index.php/RAID

I think I was reading it wrong now that I read it again. They talk about suspending the scrub, which I bet is done manually and not by the system when machine is rebooted or switched to sleep mode. If that is the case, this can easily be handled with some BASH magic in a pm-utils sleep hook.

Ivan

