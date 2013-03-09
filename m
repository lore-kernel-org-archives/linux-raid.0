From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Sat, 9 Mar 2013 14:56:44 -0500
Message-ID: <CAKHEz2ZstCbbTF-nALjSDZ7O7yW7DRSN8YpKpcpTj1Ur404NWw@mail.gmail.com>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
	<513AC802.8070306@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513AC802.8070306@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 9, 2013 at 12:26 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
>
> I'd be interested if you could test it against 3.7.9.
>
> I have a 6 drive RAID10. 3 Drives are on the on-board AHCI, and the other
> three are on an LSI 9240-8i (SAS2008 with mpt2sas module).
>
> TRIM is being passed down the stack as after an fstrim of the ext4 fs on the
> RAID the mismatch count goes through the roof.
>
> The 3 drives on the LSI are Intel 330 (which support deterministic read
> after trim) while the drives on the AHCI are Samsung 830 (which are *not*
> deterministic after trim).
>
> My raid is 6 drives in an n2 configuration, so three pairs of mirrors. Each
> one a Samsung and an Intel.
>

While I set this up could you let me know what you have in the
following sys files?

/sys/block/[mddevice]/discard_alignment
/sys/block/[mddevice]/queue/discard_granularity
/sys/block/[mddevice]/queue/discard_max_bytes

Also what chunk size is your array set to?

Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
