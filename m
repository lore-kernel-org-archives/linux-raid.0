From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Tue, 17 Jun 2014 10:09:12 +0100
Message-ID: <CADqA9uYH0g2wNghmGPCLWcSq-E8bD43Rx_gSiN68rTUHibwX_w@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
 <539EFF1C.3000009@turmel.org> <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
 <CADqA9uajh-vnYFLPyeqV4kLinGwaQDhm0kR2JA+A22OrVabuNg@mail.gmail.com> <539F9024.7040806@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539F9024.7040806@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 17, 2014 at 1:47 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> They do not, and have never had the ability to change speeds.

I didn't mean changing speeds during I/O, that would be quite a feat;
what seems to be perceived is slowing speed in idle states. Most stuff
i found pointed to 5400 though. This thread [1] points do
drive-specific fixed speed between 5400 and 5900.

The question remains: what are the implications of having 7200 drives
and 5400 drives in a RAID1, 10 or 5? It'll be as slow as the slowest
drive, correct? What about any syncing issues during a power outage?

Any takes on the Hitachis?

[1] http://marc.info/?l=linux-raid&m=136039742726982&w=2
