From: Illtud Daniel <illtud.daniel@llgc.org.uk>
Subject: Re: about the speed
Date: Wed, 02 Apr 2003 10:58:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8AB445.A76ED9D6@llgc.org.uk>
References: <3E87FC9D.5010605@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46arkas Levente wrote:

> I'm just read
> http://www.hpl.hp.com/techreports/2002/HPL-2002-352.pdf
> may be it's worth to read. an intersting thing about performance (XP,
> their user-space raid and than comes kernel raid).

Any comments from md developers? This is from the abstract:

 The paper contains preliminary results from an investigation comparing
 Linux and WindowsXP disk I/O using kernel-based software RAID on
 identical hardware. WindowsXP performance is shown to be substantially
 superior to Linux performance, for reasons not currently understood.

And the meat of the report:

 5.5. Direct comparison

 Of crucial interest is the direct comparison between WindowsXP,
 the kernel-based Linux software RAID implementation, and the
 userlevel software RAID implementation.

 From Figure 8 it can be seen that csraid generally outperforms
 the kernel-based RAID driver, and its performance is far more
 stable, particularly for large requests. Also, the WindowsXP
 RAID driver is astonishingly good, even compared to JBOD, with
 JBOD=92s performing better for request sizes smaller than 4MB
 and WindowsXP performing better at the larger sizes.

 csraid=92s performance is generally less than WindowsXP, but
 overall the loss is not catastrophic, and is likely
 sufficient for the most purposes.


=46igure 8 shows that XP's RAID can be 60+% faster than md at
writing, and up to 100% faster at reading (at request size
7MB, which is rather a blip). Any inital thoughts on this report?
Has the performance changed substantially since? The distro was
Mandrake 8.2, the kernel 2.4.18-6mdk. Any comments on the
methodology or conclusions?

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
