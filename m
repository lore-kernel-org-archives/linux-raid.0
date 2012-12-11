From: "Andris Berzins" <pkix@inbox.lv>
Subject: Re: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 11:01:35 +0200
Message-ID: <1355216495.50c6f66f123b1@mail.inbox.lv>
References: <1355182639.50c6722fe15b2@mail.inbox.lv>
 <alpine.DEB.2.00.1212110912470.17599@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1212110912470.17599@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting "Mikael Abrahamsson" <swmike@swm.pp.se>:
> On Tue, 11 Dec 2012, Andris Berzins wrote:
> 
>> I found on internet that this can be fixed if I re-create raid with the same
>> configuration, but with dead drive set as 'missing'.
> 
> This is extremely dangerous. You would have been better off by first
> trying --assemble --force.
> 
>> However, I can not mount md1 and looks like it contains random data. The
>> order is correct. However, I noticed that new raid device size is
>> different from old one.
> 
> Your data offset is different, most likely you're not using the same mdadm
> version as was initially used to create the raid. Mdadm defaults have
> changed over time regarding chink size, data offset and others.

Thank you!
I did not notice that.
Looks that I will have to try downgrade kernel:
http://serverfault.com/questions/427683/what-parameters-to-mdadm-to-re-create-md-device-with-payload-starting-at-
0x2200


> 
> I don't know off the top of my head how to change the mdadm data offset
> unfortunately.
> 
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se

