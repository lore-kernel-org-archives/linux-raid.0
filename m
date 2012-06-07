From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Wed, 06 Jun 2012 23:59:40 -0500
Message-ID: <4FD0353C.1050006@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com> <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com> <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com> <20431.57247.76819.834529@tree.ty.sabi.co.UK> <CA+sTkh6=Kn1EJ79zCxWW6Xr-H23E+-HpqJVD33vP4rJMQ3ON4g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6=Kn1EJ79zCxWW6Xr-H23E+-HpqJVD33vP4rJMQ3ON4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: Peter Grandi <pg@lxra2.to.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/6/2012 10:41 PM, Igor M Podlesny wrote:

>    They try, for sure, but try is still a try. For e. g., you pvmove'd
> your LVM with XFS from one RAID to another one having different
> "layout", things can just stop working well all of the sudden.

Filesystems that have zero awareness of the storage geometry have poor
performance on striped RAID devices.  XFS has excellent performance on
striped RAID specifically due to this awareness.  Now you describe this
strength as a weakness due to a volume portability corner case no SA in
his right mind would attempt.

The proper way to do this is to perform an xfsdump of the filesystem to
a file, create a new XFS with the proper stripe geometry in the new
storage location (which takes all of 1 second BTW), then xfsrestore the
dump file.

And now you will say "Yes, but..."

-- 
Stan
