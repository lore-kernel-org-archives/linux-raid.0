From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 16:27:43 +0200
Message-ID: <517FD4DF.3030709@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch> <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Tue, 30 Apr 2013, Roberto Nunnari wrote:
> 
>> How do I increase that timeout?
> 
> for x in /sys/block/sd[a-z] ; do echo 180  > $x/device/timeout ; done
> 

done!

Robi
