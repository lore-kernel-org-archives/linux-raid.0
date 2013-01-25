From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/3] Add support for launching mdmon via systemctl instead of fork/exec
Date: Fri, 25 Jan 2013 16:05:31 +0100
Message-ID: <wrfjd2wtl2v8.fsf@redhat.com>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
	<1358774578-2183-2-git-send-email-Jes.Sorensen@redhat.com>
	<20130122164623.1962171b@notabene.brown> <wrfjip6pvfht.fsf@redhat.com>
	<wrfjham5ldm6.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjham5ldm6.fsf@redhat.com> (Jes Sorensen's message of "Fri, 25
	Jan 2013 12:13:21 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> NeilBrown <neilb@suse.de> writes:
>>>  - I have come to the conclusion that --offroot is a bad idea.  We should
>>>    just make that the default.  No matter whether the array is providing the
>>>    root filesystem or not, I never want systemd (or anything else) to kill
>>>    mdmon.  I want it to remain in control.  So the systemctl handling should
>>>    assume offroot. e.g. there should only be one .service file.
>>
>> Ok I guess the question is what happens if an array is shut down in
>> userland, does it take mdmon down manually once it is finished with it?
>> We need this to happen, because otherwise we end up with a dangling
>> mdmon process once we reboot, if the IMSM array wasn't assembled in the
>> initrd.
>
> I have been digging some more into this. Basically it looks like we can
> nuke the --offroot argument and simply default to running that way.
>
> On the bad side, we need two different .service files, one for on the
> initrd and one for post system boot, due to different condition
> requiremnts. The question is whether to name them the same, and just
> have dracut know about the magic initrd version or if we want to try for
> the two versions.

Very odd - more testing and it looks like this may not be a problem
after all, but instead because something went wrong during the creation
of the initrd in my testing. It does make me a little concerned if this
can happen to users who are installing an update, but with nothing more
than a single incident there isn't much I can do.

I will look at a set of patches.

Jes
