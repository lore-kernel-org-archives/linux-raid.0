From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Random bit flips - better data integrity needed
Date: Sun, 20 Sep 2009 17:55:15 -0400
Message-ID: <yq17hvt5lj0.fsf@sermon.lab.mkp.net>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
	<slrnhbcijr.f3a.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnhbcijr.f3a.Mario.Holbe@darkside.dyn.samba-tng.org> (Mario
	Holbe's message of "Sun, 20 Sep 2009 17:30:03 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mario" == Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> writes:

>> With regards to data storage, one major step in this direction is the
>> "integrity" patch that went into the kernel last winter (2.6.28?).

Mario> That's far from being end-to-end. Actually, it is even against
Mario> the end-to-end argument. End-to-end means from application to
Mario> application.

Oracle has a custom (as in non-POSIX) async I/O submission interface
called oracleasm.  Hooking into my Linux kernel block integrity
infrastructure I can protect the I/O all the way from within the Oracle
DB context in userland to the drive firmware and back.

We're working on a generic (as in POSIX-like) interface that allows data
integrity passthrough for normal applications.

-- 
Martin K. Petersen	Oracle Linux Engineering
