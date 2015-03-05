From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Thu, 05 Mar 2015 09:56:16 -0500
Message-ID: <wrfj8ufb333j.fsf@ultrasam.lan.trained-monkey.org>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com> <20150219083708.2ab46006@notabene.brown>
	<wrfj61ay6fai.fsf@redhat.com> <20150219093236.25660678@notabene.brown>
	<wrfjoaobz7fz.fsf@redhat.com> <20150303084327.21ddb086@notabene.brown>
	<wrfjoao84uy4.fsf@ultrasam.lan.trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoao84uy4.fsf@ultrasam.lan.trained-monkey.org> (Jes
	Sorensen's message of "Wed, 04 Mar 2015 10:57:07 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> NeilBrown <neilb@suse.de> writes:
>> On Mon, 02 Mar 2015 11:32:16 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
>>> Neil,
>>> 
>>> Finally had time to go back and look at this - I don't quite understand
>>> your request here.
>>> 
>>> As far as I can see, the above code isn't run at all during device
>>> creation, so I don't get how modifying it as you suggest will make
>>> /dev/md/111 appear if I create /dev/md111?
>>> 
>>> Cheers,
>>> Jes
>>
>> Wheels within wheels of deception and indirection....
>>
>> mdadm doesn't create the devices directly, udev does that.
>>
>> IMPORT{program}="BINDIR/mdadm --detail --export $devnode"
>> ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", SYMLINK+="md/$env{MD_DEVNAME}"
>>
>>
>> So the symlink from /dev/md gets created iff "mdadm --detail --export"
>> reports an MD_DEVNAME.
>>
>> Hence the change suggested.
>>
>> mdadm *can* create the devices itself, but only if udev isn't running, or
>> mdamd has been explicitly told to ignore udev.  Normally that doesn't happen.
>
> Ahhh, I didn't see anything happening on my system, but it may be the
> RHEL/Fedora udev rules file is missing something. I'll have to take a
> closer look there!

Actually I remember why I didn't get that far - I added some debug code
to the place you suggested I modify, and it never triggered during
Create.

Cheers,
Jes
