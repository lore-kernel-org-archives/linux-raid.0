From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 08:54:43 -0500
Message-ID: <CAO9HMNG0-hhgj1V+8yVe6F_mqsRAiJgZf+06vo-Pt0BUEYjS0A@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
	<CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
	<CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
	<CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
	<20130607165236.60ac7451@natsu>
	<CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com>
	<51B1DD93.1010904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B1DD93.1010904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is Scientific Linux (RHEL) 6.4. That's nominally kernel 2.6.32,
but that doesn't tell one much. The RHEL kernel is the RHEL kernel,
with features selected from far more recent kernels included, more
being added with every point release. (e.g., I have the dm-thin target
available in LVM2.)

I've used both CFQ and Deadline for testing. It doesn't make a
measurable difference for either the multiple dd's or for the
single-threaded C/ISAM rebuild. (In fact, deadline, while often better
for servers, can have problems with mixed sequential/random access
workloads. At least according to what I've seen over on the PostgreSQL
lists. It's no surprise that deadline doesn't help my single-threaded
workload. Also note that deadline has shown itself to be slightly
superior to noop for SSD's in certain benchmarks.) There's no one size
fits all answer. Until the particular workload is actually tested, it
*is* guesswork. I/O scheuling is too complicated for it to be
otherwise.

The chipset supports AHCI, but unfortunately it's turned off on the
PET310, and the setting is not exposed in the BIOS setup, despite the
fact that Dell advertises AHCI capability. It would do AHCI if I
bought one of the optional SAS controllers.

Since this is an unusual RAID10 situation, and I have plenty of spare
processor available, I'm going to try RAID5 over the weekend. I've
never used it. But I'm guessing that parity might come at a lower
bandwidth cost than mirroring. Should be a fun weekend. :-)

BTW, any recommendations on chunk size?

-Steve
