From: 002@tut.by
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Fri, 08 Dec 2017 04:25:06 +0300
Message-ID: <438341512696306@web3g.yandex.ru>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
         <1865221512489329@web5g.yandex.ru>
         <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
         <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
         <20171206104905.GA4383@metamorpher.de>
         <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
         <20171206160346.GA5806@metamorpher.de>
         <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
         <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
         <20171207135832.GA4858@metamorpher.de> <20171207174048.GA6428@metamorpher.de> <5A29D169.4000203@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A29D169.4000203@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Andreas Klauer <andreas.klauer@metamorpher.de>, smartmontools-support@listi.jpberlin.de
List-Id: linux-raid.ids


> If true, this actually has quite a big impact on hobbyist raid
> installations. 
Not really. SMART Command Transport is a feature, introduced long time ago. The last Seagate desktop drive model, not implementing it, is Barracuda 7200.10 (that's from year 2006), while WD and Hitachi had it even earlier. Besides, smartmontools version 5 behave as you expect it should (just checked that). So, the hypothetical problematic drive must be very old, but reused in fresh system, and also must be affected by long timeouts. Not very probable mix, IMHO.

