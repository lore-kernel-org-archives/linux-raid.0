From: Colin McDonald <ce.mcdonald@gmail.com>
Subject: Re: RAID 1 on a server with possible mad mobo
Date: Tue, 8 Mar 2005 19:48:03 -0500
Message-ID: <bbfa528905030816484108fa7@mail.gmail.com>
References: <bbfa52890503081019478cb6cf@mail.gmail.com>
	 <422DF363.6090105@steeleye.com>
Reply-To: Colin McDonald <ce.mcdonald@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <422DF363.6090105@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the suggestions.

Let me ask an additional question.

Is it a bad idea to write the grub to a software mirror. Is it written
to a specific disk when this is done?

If I had a corrupt boot loader or boot sector and i needed to rescue.
Would I point to the md device or one of the disks (or both).

TIA


On Tue, 08 Mar 2005 13:48:03 -0500, Paul Clements
<paul.clements@steeleye.com> wrote:
> Colin McDonald wrote:
> 
> > Without taking up to much of y'alls time, what would be the best
> > solution for moving the RAID array over to a new box?
> 
> > 2. Try to boot off of the disks after they have been transferred into
> > the new machine? I know this will cause all kinds of problems with
> > kernel/devices, etc and probably won't work.
> 
> Actually, I've done this a couple of times with both Red Hat and SUSE
> and it's worked surprisingly well. With the kernel being mostly modular
> and the hardware detection/configuration utilities being pretty advanced
> these days, it's not much of a problem. (I had a minor issue with SUSE
> doing this sort of thing because the MAC address of the NIC was
> different, so the network stuff was not getting configured. On Red Hat
> [and hopefully Fedora is still the same] you should get prompted at
> bootup if there is any hardware to add or remove.)
> 
> Especially if you're wanting to keep the system configuration exactly
> the same, this may be the way to go, rather than trying to reconfigure
> everything exactly the way you had it before.
> 
> And of course if, after booting the new system with the old disks, you
> find that things are not quite right, you can always re-install at that
> point...
> 
> --
> Paul
>
