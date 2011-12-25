From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by
 smart
Date: Sat, 24 Dec 2011 19:11:08 -0500
Message-ID: <4EF66A1C.4070905@turmel.org>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com> <8762h62sgb.fsf@poker.hands.com> <4EF5E161.5010001@turmel.org> <87vcp60yxr.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vcp60yxr.fsf@poker.hands.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/24/2011 10:30 AM, Philip Hands wrote:
> On Sat, 24 Dec 2011 09:27:45 -0500, Phil Turmel <philip@turmel.org> wrote:
[...]
>> Have you set up TLER or SCTERC on these drives?
> 
> The WD Caviar Black model doesn't appear to support that, judging by the:
> 
>   Warning: device does not support SCT Error Recovery Control command
> 
> in the smartctl output.  As for TLER, threads like this:
> 
>   http://www.eggxpert.com/forums/thread/602903.aspx
> 
> suggest that there used to be a DOS utility for doing it, but that WD
> have since disabled the ability to set that -- and TBH the chances of me
> scheduling down time, and working out how to boot DOS on a system with
> no floppy, which is in a co-lo centre where I generally am not, are slim
> to say the least -- I'd be more likely to simply replace the disks if
> that's the only solution, since I'm not impressed with them so far.

Yup.  You're stuck.  I read about this and deliberately avoided WD drives.

>> I suspect you haven't, as these long delays on read errors are typical
>> of default error handling on consumer drives.
> 
> That's my understanding too.
> 
> Unfortunately, this enlightenment only came to me after I'd already
> bought the el-cheapo drives, rather than the overly expensive RAID-ready
> model.

I got burned this summer myself.  My older 1T Seagate drives support SCTERC.
I bought some 2T Seagate drives in July that don't, and didn't notice right
away that my init script was failing to set those drives.

I've since taken the 2T Seagate drives out of RAID service.  I'm using them
for non-raid non-critical media storage and for my offsite backup rotations.
Without a time limit in the drive, extreme system delays are unavoidable.  MD
does not have timeouts, so a delayed error report on one drive can block the
entire array for the duration.

I've also noticed the scattered complaints across the 'net that the major
manufacturer's are crippling SCTERC to push buyers to the enterprise drives.

> You may say that I deserve what I'm getting, but I'm rather used to
> Linux being able to get the best out of cheap hardware, and was hoping
> that this would be another example where that could be made to be the case.

I've been doing so as well, but the manufacturers are trying to close this
off.  I've identified the Hitachi Deskstar 5K3000 as a consumer-grade drive
that still supports SCTERC, but I'm not sure how long that'll last.  Careful
reading and re-reading of drive specs will be part of my future purchasing
plans.

For your situation, you either need to figure out how to tolerate the long
delays, or swap your drives for models that can report errors quickly.

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk72ahoACgkQBP+iHzflm3CE3gCfVmH2sDMBxeKxajZYyfqFB5j1
n60AnitjWSZZh88GuSc+Fps61lvCHbiI
=+R3p
-----END PGP SIGNATURE-----
