From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: udev rule and systemd unit files and  mdadm - cross distro.
Date: Wed, 11 Dec 2013 17:50:42 +0100
Message-ID: <wrfjmwk7cowt.fsf@redhat.com>
References: <20131211131223.5acbbca8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131211131223.5acbbca8@notabene.brown> (NeilBrown's message of
	"Wed, 11 Dec 2013 13:12:23 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux RAID <linux-raid@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, prajnoha@redhat.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> Hi,
>  I would really like all distros that use systemd and mdadm to use a common
>  set of unit files to run mdadm.  Similarly I would like us all to use
>  exactly the same udev rules files.
>  This is, after all, one of the benefits of open source - sharing fixes so we
>  all get a better result.  It should also make it easier to respond to
>  community issues because there are fewer differences between distros.

Neil,

Nice updates!

>  To this end:
>
>   - I've recently added some systemd unit files to mdadm and they are or will
>     be in openSUSE.  I'm hoping they will eventually make their way into
>     Fedora and any other distro that uses systemd.  I am of course happy to
>     make changes to meet needs in other distros that I'm not aware of.
>
>     The particular unit files are:
>      mdadm-last-resort@.timer  mdadm-last-resort@.service
>
>       When udev runs "mdadm -I" and finds that the array could have been
>       started degraded, but wasn't because there is good reason to believe
>       that more devices will appear, it adds to SYSTEMD_WANTS
>            mdadm-last-resort@mdXXX.timer
>       This waits 30 seconds and then runs mdadm-last-resort@mdxxx.service
>       which starts the array if possible.
>       If another device has appeared and the array has already been started,
>       this will simply do nothing.
>       This means that if you shut down, remove a device, then reboot you get
>       a 30 second pause and the array starts.  That is better than the
>       current situation where the array doesn't start.
>
> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=169ffac7ad7748c8586fd1d68b7a417d71133140

I am always wary of setting timeouts like this, but I am not sure there
is a better solution. In particular what happens on a system which has a
*lot* of arrays, in this case 30 seconds simply may not be enough. A
crazy config with raid run on top of a LUKS device requiring password
would be even worse, but ok, anyone doing that kinda deserve what they
get :)

>
>     mdmonitor.service
>
>       This is similar in purpose to the mdmonitor.service from Fedora, but
>       different in detail.  In particular whenever a RAID[1-9]* array starts,
>       udev adds this service to SYSTEMD_WANTS so that "mdadm --monitor" will
>       automatically be started when needed, but never before.  So there is no
>       need to explicitly "enable" this service.
>
>       Doug/Jes: do you see a problem with switching to this in due course?
>
> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=61c094715836e76b66d7a69adcb6769127b5b77d

I don't see any issues with this off hand. I will need to run some
testing with it, but I like the idea of getting the files cleaned up and
shared across distros. There were some issues related to SYSTEMD_WANTS
in Fedora the other day, so Peter may have some input (added to CC).

>   - I've had a look at the Fedora udev rules files and brought a few ideas
>     across to the udev files in the mdadm distro.  They are possibly
>     irrelevant for other distros, but they shouldn't hurt.  There was a
>     bug-fix though.
>     There are a few bits that I haven't brought in yet, mostly relating to
>     the state of DM devices.
>
> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=05ec50a57badfd220373aa06afd7d3fac0beb49f
> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=25392f5fc59f96fb766ecb5617d5276f8c87d489
>
>  So if there are any distro maintainers out there (or anyone else who might
>  be interested), I'd love to hear about other things that might need to be in
>  common unit or rules files.  Having said that though I'll shortly be going
>  on Christmas/New Year leave so I'm not expecting a quick resolution to all
>  of this.  I'm happy to collect ideas though and would like to have something
>  fairly coherent before 3.3.1 which I'd like to see in February.
>
>  I'm quite aware that distro will have real differences for various reasons.
>  If at all possible I'd like to be able to localise those to separate files.
>  One example is the way arguments are passed to "mdadm --monitor" by
>  mdmonitor.service.
>  Fedora appears to not pass many arguments - presumably the important values
>  are in /etc/mdadm.conf.
>  openSUSE does pass lots of arguments generated from information
>  in /etc/sysconfig/mdadm (which is edited directly by our sysadmin tool
>  "yast").
>  The mdmonitor.service file I have written will run a script
>     /usr/lib/systemd/scripts/mdadm_env.sh
>  and then read environment variables from /run/sysconfig/mdadm.  The script
>  writes there and a value written there is used as the arguments for mdadm.
>  I've included a SUSE-specific version of mdadm_env.sh.  Other distros might
>  provide something else.  If the file doesn't exist, then sensible defaults
>  are used.  I hope a similar approach can be used to factor out any other
>  distro-specific rules that might be needed.

I think allowing an /etc/sysconfig/mdadm in Fedora would be just fine
too, in which case your script should more or less suit us as well. It's
something I need to play with though, but it would be fine with me.

February (early) for 3.3.1 would be good for us too, fwiw.

Cheers,
Jes
