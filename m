From: Nix <nix@esperi.org.uk>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 13:26:33 +0100
Message-ID: <875zbi3r46.fsf@esperi.org.uk>
References: <rco1i8$1l34$1@ciao.gmane.io>
        <24305.24232.459249.386799@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24305.24232.459249.386799@quad.stoffel.home> (John Stoffel's
        message of "Mon, 22 Jun 2020 21:45:12 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Jun 2020, John Stoffel told this:

> You also don't say how *big* your disks will be, and if your 5 bay NAS
> box can even split like that, and if it has the CPU to handle that.
> Is it an NFS connection to the rest of your systems?

Side note: NFSv4 really is much much better at this stuff than v3 ever
was. With a fast enough network connection, I find NFSv4 as fast for
more or less all workloads as NFSv3 was, mostly because of the lease
support in v4 allowing client-side caching of the vast majority of files
and directories that are either not written to or only written to by one
client in a given short time window. (Obviously it also helps if your
network is fast enough: 1GbE is going to be saturated many times over by
a RAID array of any but the slowest modern HDDs. 10GbE and small
10GbE-capable switches are not very costly these days and is definitely
worth investing in on the NFS server and any clients you care about.)
