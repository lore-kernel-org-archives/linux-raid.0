From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 13:21:27 -0500
Message-ID: <1194027687.11827.32.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
	 <1193944573.10336.684.camel@firewall.xsintricity.com>
	 <1193992909.3649.75.camel@w100>
	 <1194018326.25553.28.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194018326.25553.28.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-11-02 at 11:45 -0400, Doug Ledford wrote:

> The key word here being "supported".  That means if you run across a
> problem, we fix it.  It doesn't mean there will never be any problems.

On hardware specs I normally read "supported" as "tested within that
OS version to work within specs". I may be expecting too much.

> I'm sorry, but given the "specially the RHEL" case you cited, it is
> clear I can't help you.  No one can.  You were running first gen
> software on first gen hardware.  You show me *any* software company
> who's first gen software never has to be updated to fix bugs, and I'll
> show you a software company that went out of business they day after
> they released their software.

I only pointed to RHEL as an example since that was a particular
distro that I use and exhibited the problem. I probably could of
replaced it with Suse, Ubuntu, etc. I may have called the early
versions back in 94 first gen but not today's versions. I know I 
didn't expect the SLS distro to work reliably back then. 

Thanks for reminding me on what I should and shouldn't consider 
first gen. I guess I should always wait for a couple of updates
prior to considering a distro stable, I'll keep that in mind in 
the future.

> I *really* can't help you.

And I never expected you to. None of my posts asked for support
to get my specific hardware and kernels working. I did ask for
help identifying combinations that work and those that don't.

The thread on low level timeouts within MD was meant as a forward
thinking question to see if it could solve some of these problems.
It has been settled that no, so that's that. I am really not trying
to push the issue with MD timeouts.

> No, your experience, as you listed it, is that
> SATA/usb-storage/Serverworks PATA failed you.  The software raid never
> failed to perform as designed.

And I never said that software raid did anything outside what it
was designed to do. I did state that when the goal is to keep the
server from hanging (a reasonable goal if you ask me) the combination
of SATA/usb-storage/Serverworks PATA with software raid is not
a working solution (neither it is without software raid for that
matter)

> However, one of the things you are doing here is drawing sweeping
> generalizations that are totally invalid.  You are saying your
> experience is that SATA doesn't work, but you aren't qualifying it with
> the key factor: SATA doesn't work in what kernel version?  It is
> pointless to try and establish whether or not something like SATA works
> in a global, all kernel inclusive fashion because the answer to the
> question varies depending on the kernel version.  And the same is true
> of pretty much every driver you can name.  This is why commercial

At time of purchase the hardware vendor (Supermicro for those
interested) listed RHLE v3, which is what got installed.

> companies don't just certify hardware, but the software version that
> actually works as opposed to all versions.  In truth, you have *no idea*
> if SATA works today, because you haven't tried.  As David pointed out,
> there was a significant overhaul of the SATA error recovery that took
> place *after* the kernel versions that failed you which totally
> invalidates your experiences and requires retesting of the later
> software to see if it performs differently.

I completely agree that retesting is needed based on the improvements
stated. I don't think it invalidates my experiences though, it does
date them, but that's fine. And yes, I see your point on always listing
specific kernel versions I will do better with the details in the
future.

> I've had *lots* of success with software RAID as I've been running it
> for years.  I've had old PATA drives fail, SCSI drives fail, FC drives
> fail, and I've had SATA drives that got kicked from the array due to
> read errors but not out and out drive failures.  But I keep at least
> reasonably up to date with my kernels.
> 
Can you provide specific chipsets that you used (specially for SATA)? 

Thanks,

Alberto


