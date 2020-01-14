From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Debian Squeeze raid 1 0
Date: Tue, 14 Jan 2020 09:08:46 +0100
Message-ID: <CAJH6TXjaTiSyXLF61irJdZ4QUyMwdc0+dGV+sYRDGJsO15P_XQ@mail.gmail.com>
References: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
 <5E1D6C8E.8030607@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E1D6C8E.8030607@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Rickard Svensson <myhex2020@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno mar 14 gen 2020 alle ore 08:24 Wols Lists
<antlists@youngman.org.uk> ha scritto:
> The fact that the three event counts we have are near-identical is a
> good sign. The worry is that sde2 disappeared a long time ago - have you
> been monitoring the system? If you ddrescue it will it give an event
> count almost the same as the others? If it does, that makes me suspect a
> controller issue has knocked two drives out, one of which has recovered
> and the other hasn't ...

But as I can see, two drives are out on a RAID1+0 array, so the array is gone.
I think we can only hope that these two disks were on different
mirrors (but this isn't
easily readable on mdadm output, I think i've sent an email asking for
a better output
some days ago)

That's why I really really really hate anything with redundancy < 2,
like a standard RAID1+0
Only 3way mirrors or RAID6 here.
