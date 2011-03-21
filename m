From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Mon, 21 Mar 2011 12:07:45 -0500
Message-ID: <4D8785E1.6060700@hardwarefreak.com>
References: <4D7E0994.3020303@hardwarefreak.com>	<20110314124733.GA31377@infradead.org>	<4D835B2A.1000805@hardwarefreak.com>	<20110318140509.GA26226@infradead.org>	<4D837DAF.6060107@hardwarefreak.com>	<20110319090101.1786cc2a@notabene.brown>	<4D8559A2.6080209@hardwarefreak.com>	<20110320144147.29141f04@notabene.brown>	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>	<4D868C36.5050304@hardwarefreak.com>	<20110321024452.GA23100@www2.open-std.org>	<AANLkTikZ1_QmpbBV3utKZdSW_pKyHvsb8aDK1PP4Lhn3@mail.gmail.com> <AANLkTi=gByD=Xe_ik3R-YVG5tE+F_gfaM2W5KvMiROGY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=gByD=Xe_ik3R-YVG5tE+F_gfaM2W5KvMiROGY@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Roberto Spadim put forth on 3/20/2011 10:14 PM:
> with hardware raid we don't think about this problem, but with
> software we should consider since we run others app with software raid
> running too

Which is precisely why I asked Neil about this.  If you recall Neil
stated that CPU burn shouldn't be an issue when using mdraid linear over
16 mdraid 10 arrays in the proposed system.  As long as the kernel
somewhat evenly distributes IO steams amongst multiple cores I'm
inclined to agree with Neil.

Note that the application in this case, the NFS server, is threaded
kernel code, and thus very fast and scalable across all CPUs.  By
design, all of the performance critical code in this system runs in
kernel space.

-- 
Stan
