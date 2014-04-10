From: David Brown <david.brown@hesbynett.no>
Subject: Re: Nvidia Raid5 Failure
Date: Thu, 10 Apr 2014 10:46:10 +0200
Message-ID: <53465A52.7080807@hesbynett.no>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: peter davidson <merrymeetpete@hotmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/04/14 07:00, peter davidson wrote:
> Hi Folks,
> 
> My computer suddenly shut down due to a failed memory module -
> damaging the 1.8TB RAID5 array of three disks.
> 
> The computer was able to boot with a degraded array (Windows 7 OS was
> on the array) but I was unable to get the array to rebuild using the
> Nvidia toolset - either at BIOS level or in Windows 7. Now the
> computer will not boot from the array.
> 
> I had something very similar to this happen a few weeks ago when the
> mother board failed - I was able to limp things along to get a backup
> of all important data.
> 
> I am interested to know if LINUX will be able to recover the array
> for me this time. Having got part way through this process before on
> the previous failure (which led me to this forum), I am keen to
> follow this through as an exercise knowing I have a backup of the
> really important stuff.
> 
> I intend to build LINUX onto a new disk and work through this in the
> coming days - what would be my best choice of distro for this
> exercise? I am hoping to find something that has all the relevant
> tools and is relatively simple to get up and running with a friendly
> GUI to help me navigate round.
> 
> I used to work on various databases running on UNIX servers so I hope
> I can still can find my way round a terminal window.
> 
> Thanks in advance for any support anyone can offer me!
> 
> Regards,
> 

As a general point, don't do /anything/ to write to the disks or attempt
to recover or rebuild them until you have copied off /all/ important
data to safe backups.  If you have booted Windows from the array, then
step one is to shut it down and do not even consider booting it until
backups are all in place and double-checked.

You want to use a live CD for recovery here - it will let you play
around with the disks without risking causing more damage.  My usual
choice of Linux live CD for recovery purposes is System Rescue CD - I
can't tell you if it is the best choice here, and I haven't needed to
recover raid arrays using it.  But I find it very useful for testing and
configuration, and have used it to recover data or fix up broken Windows
systems.

Another option you should consider is a Windows live CD.  You can't
legally download and burn one, AFAIK, but there are plenty available if
you are happy to look about.  There are also several Windows live CD
generators that will make a bootable Windows CD from another windows
machine, and can include utility programs.  They are particularly
popular for malware recovery, but I expect you can put your Nvidia raid
software on them.

As for how well you can access the data and/or recover and/or rebuild
your array from Linux, it all depends on the support for your Nvidia
raid.  Someone here might have experience and can give you information,
but your best starting point would be Nvidia's website.  There are Linux
drivers and utilities for most proper hardware raid systems, but if this
is a Nvidia-specific fake raid, it might not be supported.  Fake raid is
not very popular in the Linux world - it combines the disadvantages of
software raid with the disadvantages of hardware raid, and the benefits
of neither.  It's only real advantage is if you want to use Windows with
raid and don't want to pay for proper hardware raid.  Intel's "matrix"
is far and away the most popular fake raid, and has good support in
Linux, but I cannot say about Nvidia's raid.


If you want to set up a new system with Linux raid, then you will be
able to get pointers and help in this list - but it's not really
suitable for "how to get started with Linux" information.  And if you
want to mix Windows and Linux on the same system, be aware that Windows
can't work with Linux software raid, and can't understand Linux
filesystems (at least, not easily).  It is often much easier to keep
them on separate machines and sharing files over the network.
Alternatively, consider using VirtualBox to let you run one system as a
virtual machine inside the other.

mvh.,

David
