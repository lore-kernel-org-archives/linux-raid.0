From: Nix <nix@esperi.org.uk>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Mon, 10 Apr 2017 10:26:50 +0100
Message-ID: <878tn8ipet.fsf@esperi.org.uk>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
        <87h922trit.fsf@notabene.neil.brown.name>
        <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
        <87vaqhyx4i.fsf@notabene.neil.brown.name> <wrfjinmgqkjc.fsf@gmail.com>
        <878tn9yymi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tn9yymi.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 10 Apr 2017 09:01:09 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: jes.sorensen@gmail.com, linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

On 10 Apr 2017, NeilBrown verbalised:

> On Fri, Apr 07 2017, jes.sorensen@gmail.com wrote:
>
>> Next question since I am wearing my 'what is this old stuff doing' hat.
>> mdassemble? Does anything still use this? The reason is a lot of the
>> newer features are explicitly included, and switching to sysfs is
>> effectively going to kill it, unless it gets a major upgrade.
>>
>
> I was never a big fan, of mdassemble, but it is smaller than mdadm and
> some people apparently have (or had) space-constrained boot
> environments.

It also has fewer build-time requirements and can build on systems with
things like old buggy versions of uclibc that can't build a working
mdadm. (Of course, now musl exists, I'm not sure anyone should care
about that. I stopped caring many years ago.)

-- 
NULL && (void)
