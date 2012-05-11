From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 10:50:19 +0400
Message-ID: <4FACB6AB.40104@msgid.tls.msk.ru>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com> <4FABE724.40103@turmel.org> <4FAC0C05.1090007@pocock.com.au> <4FAC1259.6090407@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC1259.6090407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Daniel Pocock <daniel@pocock.com.au>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10.05.2012 23:09, Phil Turmel wrote:
>> For my old Barracuda 7200.12 that is still working, I see this:
>> > 
>> > SCT Error Recovery Control:
>> >            Read: Disabled
>> >           Write: Disabled
> You should try changing it.  Drives that don't support it won't even
> show you that.

You made me curious and I checked 3 identical drives I have
in raid setup in my server.  These are (somewhat oldish by
now) WD Caviar Black 640Gb ones.  Here are the identifies:

Model Family:     Western Digital Caviar Black family

Device Model:     WDC WD6401AALS-00L3B2
Serial Number:    WD-WCASYA623503
Firmware Version: 01.03B01

Device Model:     WDC WD6401AALS-00L3B2
Serial Number:    WD-WCASY4134266
Firmware Version: 01.03B01

Device Model:     WDC WD6401AALS-00L3B2
Serial Number:    WD-WCASY4137254
Firmware Version: 01.03B01


First one is more recent, bought about a year after last 2.
As you can see, everything looks exactly the same, incl.
exact model number and firmware version.  Yet, the more
recent (first) does NOT support SCT Error Recovery Control,
returning error to any -l strec command, but the other 2,
which are older, supports setting these parameters (but
I've no idea if the timeouts will actually be used by the
firmware, this is entirely different question :).  So,
3 identical drives bought within a year, shows identical
versions and models, but behaves differently...

I also noticed that all recent desktop drives from WD does
NOT support strec, while older ones tend to support it.
Which goes on-par with what others are saying.  I wonder
how this goes in drives of other manufacturers...

Thanks,

/mjt
