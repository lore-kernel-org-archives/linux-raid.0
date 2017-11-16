From: Tobx <net@tobx.de>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Thu, 16 Nov 2017 08:31:52 +0100
Message-ID: <8CD406A8-52E6-4024-89F6-B92842B9B1FD@tobx.de>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
 <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
 <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
 <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
 <86F8F078-A7B4-4AF6-AE7B-6929161850FA@tobx.de>
 <7c1129bf-22eb-dbb2-7f3b-d3b8844dc92d@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c1129bf-22eb-dbb2-7f3b-d3b8844dc92d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: llowrey@gmail.com, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Song Liu <liu.song.a23@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Larkin Lowrey wrote:
> The "spares=1" is for the journal device. The "mdadm --examine --scan" command produced that for me as well but since it seemed odd I deleted that part. Since there isn't actually a spare it seems incorrect. I've never tried to boot with "spares=1" so I don't know if removing it will make any difference.
Yes, I tried that, seemed odd to me too, I also tried just:
ARRAY /dev/md/test UUID=d59de5cc:02f560ed:ebcb9400:491955d7

Rudy Zijlstra wrote:
> Did you update the initrd after creating the array?

Yes.

> Tobx wrote:

>> I tried this with Debian Stretch (4.9.0-4), Debian Stretch (4.13.0-0) and Ubuntu 17.10 (4.13.0-16).

> Tobx wrote:
>> I compiled mdadm from source and tried again with:
>> 
>> # mdadm --version
>> mdadm - v4.0 - 2017-01-09

Song Liu wrote:
> Your mdadm is a little old. Could you please try rebuild it from
> latest source code?

Do you have something newer?

It always works without the journal option (except I set something very wrong of course) and also with the option, but then it never assembles automatically after reboot.

I am testing everything in VMware mostly on a clean Debian installation. Might VMware be the problem? I have no other test system in place.

Cheers,
Tobi