From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 15:20:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517FC46A.1080702@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 30 Apr 2013, Roberto Nunnari wrote:

> How do I increase that timeout?

for x in /sys/block/sd[a-z] ; do echo 180  > $x/device/timeout ; done

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
