From: Drew <drew.kay@gmail.com>
Subject: Re: sas driver lockup during raid reshape. recoverable?
Date: Thu, 6 Jun 2013 05:47:58 -0700
Message-ID: <CACJz6QtfCx-QC1FPhSvK2eGDXGD7NqepUq=EjAzCBZJXTG7t3g@mail.gmail.com>
References: <CAF82EXfyLStKq3v7tJwmsHhB+731qgTZ9cUOWQncBEHk9pa4dQ@mail.gmail.com>
 <CAF82EXfXOrWtC-n765sKAxmfdfnOvH8BDReaHwrEi0oA1mT_Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF82EXfXOrWtC-n765sKAxmfdfnOvH8BDReaHwrEi0oA1mT_Jw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Claude,

I can't speak to any data loss as I don't know the answer.

One observation however. With 7 disks in a RAID-5 and a hotspare(?),
you really should be looking into RAID-6. It'll use that spare drive
but be a lot safer.

Hot Spares only get pulled into an array on drive failure, triggering
a full rebuild. That leaves your entire array vulnerable until the
rebuild finishes. With RAID-6, that spare is already part of the array
so a single disk failure anywhere won't leave your array vulnerable
while you replace the broken disk.

Just my $0.02.

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
