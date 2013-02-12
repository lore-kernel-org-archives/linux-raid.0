From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance
Date: Tue, 12 Feb 2013 08:34:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302120829440.32644@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com>
 <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com>
 <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5119AD1C.8030000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Feb 2013, Stan Hoeppner wrote:

> groups based on L3/4 info.  Stock 802.3ad won't do this.  I apologize

It's my understanding that 802.3ad (LACP) doesn't specify how packets 
should be spread over available ports, that is up to the implementor to 
decide, and it's always the packet egress device that decides what link to 
put the packet on. 802.3ad LACP is control plane, not forwarding plane.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
