From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Fri, 14 Jun 2013 16:18:09 -0500
Message-ID: <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 13, 2013 at 9:08 PM, Phil Turmel <philip@turmel.org> wrote:
> Please interleave your replies, and trim unnecessary quotes.

No problem.

>> smartctl -l scterc,70,70 /dev/sdc
>> smartctl -l scterc,70,70 /dev/sdd
>> for x in /sys/block/sd[abef]/device/timeout ; do echo 180 >$x ; done
>
> This must be done now, and at every power cycle or reboot.  rc.local or
> similar distro config is the appropriate place.  (Enterprise drives
> power up with ERC enabled.  As do raid-rated consumer drives like WD Red.)

Seems that the drives themselves retained the ERC settings after a
reboot.  But I went ahead and put scterc and the timeouts in rc.local.

>
> Then stop and re-assemble your array.  Use --force to reintegrate your
> problem drives.  Fortunately, this is a raid6--with compatible timeouts,
> your rebuild will succeed.  A URE on /dev/sdd would have to fall in the
> same place as a URE on /dev/sde to kill it.

It worked.  Yer a wizard!  Thank you!

> Finally, after your array is recovered, set up a cron job that'll
> trigger a "check" scrub of your array on a regular basis.  I use a
> weekly scrub.  The scrub keeps UREs that develop on idle parts of your
> array from accumulating.  Note, the scrub itself will crash your array
> if your timeouts are mismatched and any UREs are lurking.

I'll definatly do this.  When you talk about mismatched timeouts, do
you mean matched between each of the components (as in
/sys/block/sdX/device/timeout) or between that driver timeout and some
device timeout per component?  If you mean between components, are my
timeouts matched now, even though I did not raise the 30 seconds on
the two drives with ERC?

On Fri, Jun 14, 2013 at 4:16 PM, Barrett Lewis
<barrett.lewis.mitsi@gmail.com> wrote:
> On Thu, Jun 13, 2013 at 9:08 PM, Phil Turmel <philip@turmel.org> wrote:
>> Please interleave your replies, and trim unnecessary quotes.
>
> No problem.
>
>>> smartctl -l scterc,70,70 /dev/sdc
>>> smartctl -l scterc,70,70 /dev/sdd
>>> for x in /sys/block/sd[abef]/device/timeout ; do echo 180 >$x ; done
>>
>> This must be done now, and at every power cycle or reboot.  rc.local or
>> similar distro config is the appropriate place.  (Enterprise drives
>> power up with ERC enabled.  As do raid-rated consumer drives like WD Red.)
>
> Seems that the drives themselves retained the ERC settings after a
> reboot.  But I went ahead and put scterc and the timeouts in rc.local.
>
>>
>> Then stop and re-assemble your array.  Use --force to reintegrate your
>> problem drives.  Fortunately, this is a raid6--with compatible timeouts,
>> your rebuild will succeed.  A URE on /dev/sdd would have to fall in the
>> same place as a URE on /dev/sde to kill it.
>
> It worked.  Yer a wizard!  Thank you!
>
>> Finally, after your array is recovered, set up a cron job that'll
>> trigger a "check" scrub of your array on a regular basis.  I use a
>> weekly scrub.  The scrub keeps UREs that develop on idle parts of your
>> array from accumulating.  Note, the scrub itself will crash your array
>> if your timeouts are mismatched and any UREs are lurking.
>
> I'll definatly do this.  When you talk about mismatched timeouts, do
> you mean matched between each of the components (as in
> /sys/block/sdX/device/timeout) or between that driver timeout and some
> device timeout per component?  If you mean between components, are my
> timeouts matched now, even though I did not raise the 30 seconds on
> the two drives with ERC?
