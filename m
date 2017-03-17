From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Bit-Rot
Date: Fri, 17 Mar 2017 10:37:09 -0500
Message-ID: <BD49CADF-6076-44CF-8291-DFE74EA2C6A7@redhat.com>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com> <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk> <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com> <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se> <20170306115648.GG7497@reaktio.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170306115648.GG7497@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Pasi_K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Mar 6, 2017, at 5:56 AM, Pasi Kärkkäinen <pasik@iki.fi> wrote:
> 
> On Sun, Mar 05, 2017 at 09:15:39AM +0100, Mikael Abrahamsson wrote:
>> On Fri, 3 Mar 2017, Gandalf Corvotempesta wrote:
>> 
>>> This is what ZFS does. This is what Gluster does. This is what BRTFS does.
>>> Adding this in mdadm could be an interesting feature.
>> 
>> This has been discussed several times. Yes, it would be interesting.
>> It's not easy to do because mdadm maps 4k blocks to 4k blocks. Only
>> way to "easily" add this I imagine, would be to have an additional
>> "checksum" block, so that raid6 would require 3 extra drives instead
>> of 2.
>> 
>> The answer historically has been "patches welcome".
>> 
> 
> There was/is an early prototype implementation of checksums for Linux MD RAID:
> 
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-presentation.pdf
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-code.tar.bz2
> 
> 
> Also there's the T10 DIF / DIX (Data Integrity Fields / Data Integrity eXtensions) functionality that could be used, at least if the hardware setup is SAS-based (SAS HBA + enterprise SAS disks and modern enough firmware on both that enable DIF/DIX..).
> 
> I guess MD RAID could also 'emulate' T10 DIF/DIX even if the HBA/disks don't support it.. but dunno if that makes any sense.

There is a device-mapper target that is designed to do precisely this - dm-integrity (see dm-devel mailing list).  It currently being developed as part of an authenticated encryption project, but could be used for this too.  Note that there is a performance penalty that comes from emulating this.

 brassow

