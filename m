From: Illtud Daniel <illtud.daniel@llgc.org.uk>
Subject: Re: RAID backup
Date: Fri, 04 Oct 2002 11:25:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D9D6C84.F1736E15@llgc.org.uk>
References: <CFEAJJEGMGECBCJFLGDBCENHCEAA.enorwood@effrem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Effrem Norwood <enorwood@effrem.com>
Cc: Kanoalani Withington <kanoa@cfht.hawaii.edu>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, jbradford@dial.pipex.com, jakob@unthought.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Effrem Norwood wrote:

> In addition, HSM software costs
> something (even if you write it yourself) on top of the tape infrastr=
ucture.
> One customer of ours was quoted 40K per TB of HSM *software* alone.

I've got 25TB uncompressed of HSM here, and it's cost us (ex VAT)
roughly:

=A310k for the first 1.6TB (on NT, DLT library)
=A318k for the next  6.0TB (on NT, LTO library)
=A345k for the next 18.0TB (on Solaris, LTO Library)

=2E..for the software licencing alone. Plus about 10% pa. in support
costs.
You're looking at about 50-60% of the library cost for the HSM software
to manage it (tapes are another thing). Is HSM really that difficult?

It really is a racket, but it's not so much compared with the
cost of re-producing the data (mainly digitized collections).
I'd be happier about it if they were more reliable (libs and s/w).
Disk arrays, on the other hand, would cost us a fortune in
upgrading the cooling - we've had to do this once just because of
the 3-4 TB of online storage we've got, and adding huge exchangers
(and associated pipes) isn't something I want to do much of.

Oh, and having spent much of last night and this morning dealing
with multiple SCSI disk failures, and having seen about 5% of
ours fail in a year, I'm rapidly seeing the light on IDE.

--=20
Illtud Daniel                                 illtud.daniel@llgc.org.uk
Uwch Ddadansoddwr Systemau                       Senior Systems Analyst
Llyfrgell Genedlaethol Cymru                  National Library of Wales
Yn siarad drosof fy hun, nid LlGC   -  Speaking personally, not for NLW
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
