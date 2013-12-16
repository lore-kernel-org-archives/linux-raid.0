From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Help with degraded array
Date: Mon, 16 Dec 2013 17:21:51 -0600
Message-ID: <52AF8B0F.4040800@suddenlinkmail.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>	<52AC351E.5050709@suddenlinkmail.com>	<CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>	<52ACA2A0.4060405@suddenlinkmail.com> <CAB1R3sgU5eOh_MTtY=7ZwWwbvQV6py2dzNFku0PKzjB4-oEuRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgU5eOh_MTtY=7ZwWwbvQV6py2dzNFku0PKzjB4-oEuRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/14/2013 06:34 PM, Alex wrote:
> I ran a short (which succeeded) then a long (which also succeeded)
> test on /dev/sdc.
> 
> I realized that /dev/sdc2 is a non-raid partition mounted as /boot, so
> it can't be checked.
> 
> This box is in a remote datacenter. Still think it's okay to boot remotely?
> 
> Thanks,
> Alex

Alex,

  I think the drive is fine. It looks like a momentary hiccup (bad
block/cylinder, etc..) If it smartctl tested OK, then there is no reason to
think it dying/dead.

  You can always just stop the array and then attempt to start (--assemble) it
before you reboot. That is probably a conservative approach to take before
reboot.  Of course things can always go haywire and fail, but I have boxes I
manage remotely and routinely reboot without issues. It obviously booted fine
with the reassignment of sda->sdc occurred.

  Good luck.

-- 
David C. Rankin, J.D.,P.E.
