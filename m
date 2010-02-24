From: Felipe Alvarez <felipe.alvarez@gmail.com>
Subject: Fwd: Majordomo results: Re: Majordomo results: .
Date: Wed, 24 Feb 2010 18:54:34 +1000
Message-ID: <e4ae6451002240054q4cb517a3m4715046647e2d68c@mail.gmail.com>
References: <S1753924Ab0BXIaN/20100224083013Z+196@vger.kernel.org>
	<e4ae6451002240032q17390a5ci4baa86cc7be8270e@mail.gmail.com>
	<e4ae6451002240048w7822735dx6143c07274fe99d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4ae6451002240048w7822735dx6143c07274fe99d5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list. I've 4 X 320GB Sata disks in Raid 5 (mdadm - v2.6.7.1 - 15th
October 2008). They all have a 0xFD raid autodetect parition, filling
100% of the drives. One drive failed, and I bought a 500GB disk
(instead of 320GB). Should I just add /dev/sde as-is, allowing mdadm
to automatically rebuild it as required? Or, should I partition it to
exact same dimensions/size as the other disks, with part-type 0xFD?
TIA

Felipe
end
