From: Kanoalani Withington <kanoa@cfht.hawaii.edu>
Subject: Re: RAID backup
Date: Fri, 04 Oct 2002 08:58:46 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D9DE4E6.7070800@cfht.hawaii.edu>
References: <CFEAJJEGMGECBCJFLGDBCENHCEAA.enorwood@effrem.com> <3D9D6C84.F1736E15@llgc.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Illtud Daniel <illtud.daniel@llgc.org.uk>
Cc: Effrem Norwood <enorwood@effrem.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, jbradford@dial.pipex.com, jakob@unthought.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Illtud Daniel wrote:

>Effrem Norwood wrote:
>
>>In addition, HSM software costs
>>something (even if you write it yourself) on top of the tape infrastr=
ucture.
>>One customer of ours was quoted 40K per TB of HSM *software* alone.
>>
>
>I've got 25TB uncompressed of HSM here, and it's cost us (ex VAT)
>roughly:
>
>=A310k for the first 1.6TB (on NT, DLT library)
>=A318k for the next  6.0TB (on NT, LTO library)
>=A345k for the next 18.0TB (on Solaris, LTO Library)
>
>...for the software licencing alone. Plus about 10% pa. in support
>costs.
>You're looking at about 50-60% of the library cost for the HSM softwar=
e
>to manage it (tapes are another thing). Is HSM really that difficult?
>
>It really is a racket, but it's not so much compared with the
>cost of re-producing the data (mainly digitized collections).
>I'd be happier about it if they were more reliable (libs and s/w).
>Disk arrays, on the other hand, would cost us a fortune in
>upgrading the cooling - we've had to do this once just because of
>the 3-4 TB of online storage we've got, and adding huge exchangers
>(and associated pipes) isn't something I want to do much of.
>
I agree it's a total racket. I've spent an appalling amount of money on=
=20
this stuff over the years considering how simple it is. Last year I=20
finally built mtx, the open source tape library driver, and wrote my ow=
n=20
software in tcl scripts for a new archiving system. It really is that=20
simple, I don't know how they can charge so much for thier software,=20
especially when some it is junk to begin with.

-Kanoa

>
>
>Oh, and having spent much of last night and this morning dealing
>with multiple SCSI disk failures, and having seen about 5% of
>ours fail in a year, I'm rapidly seeing the light on IDE.
>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
