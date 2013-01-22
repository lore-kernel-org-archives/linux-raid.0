From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/3] Add support for launching mdmon via systemctl instead of fork/exec
Date: Tue, 22 Jan 2013 08:33:34 +0100
Message-ID: <wrfjip6pvfht.fsf@redhat.com>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
	<1358774578-2183-2-git-send-email-Jes.Sorensen@redhat.com>
	<20130122164623.1962171b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130122164623.1962171b@notabene.brown> (NeilBrown's message of
	"Tue, 22 Jan 2013 16:46:23 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Mon, 21 Jan 2013 14:22:56 +0100 Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> To launch mdmon via systemctl, a new command line argument is added to
>> mdadm '--systemctl'. Alternatively it is possible to set the
>> environment variable MDMON_SYSTEMCTL.
>> 
>> This allows for having mdmon launched via systemctl which avoids
>> problems with it getting killed by systemd due to it ending up in the
>> parent's cgroup (udev).
>> 
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Thanks Jes.  This is certainly something that we want in some form.
> Some issues:
>
>  - I have come to the conclusion that --offroot is a bad idea.  We should
>    just make that the default.  No matter whether the array is providing the
>    root filesystem or not, I never want systemd (or anything else) to kill
>    mdmon.  I want it to remain in control.  So the systemctl handling should
>    assume offroot. e.g. there should only be one .service file.

Ok I guess the question is what happens if an array is shut down in
userland, does it take mdmon down manually once it is finished with it?
We need this to happen, because otherwise we end up with a dangling
mdmon process once we reboot, if the IMSM array wasn't assembled in the
initrd.

>  - on my machine (openSUSE), systemctl is in /bin, not /usr/bin.
>    Would I be correct in thinking that on your machine, /bin is a symlink
>    to /usr/bin?  If so, maybe we can just use "/bin/systemctl"?  If not,
>    we might need to try a few different options.
>    Similarly I have mdmon in /sbin, not /usr/sbin.  We we cannot all
>    use /sbin, we might need to 'sed' the .service file on installation to
>    match the current system.
>    (I note that you didn't get Makefile to install the .services files.  I
>    think we want it to - at least optionally)

This was done due to the big ->/usr move, I was assuming SuSE was going
the same way? This move isn't actually something which I think was a
great idea, but it's what has been forced upon us, so I tried to stick
to it.

I didn't want to force install the .service files but if you find it's a
good idea, I am not against that.

>  - I want the default behaviour to "do the right thing" in most case, but it
>    should be possible  to over-rid (by command line option or env var or
>    both).
>    So I think I would like it to try systemctl and if that fails for some
>    reason (either because the binary doesn't exist, or because it finds that
>    the .services file doesn't exist), then it should try to exec mdmon
>    directly.
>    This default could be over-ridden to always run mdmon directly.

This should be quite easy to do. I actually made it fail explicitly so
the user knows it fails when they try to run it via systemctl. However
if we take this approach, maybe we should also default to always trying
via systemctl before exec().

Cheers,
Jes
