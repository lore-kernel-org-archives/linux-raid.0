From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Moving controllers
Date: Tue, 23 Mar 2004 15:20:43 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40601D8B.6050906@wasp.net.au>
References: <24101.194.60.85.4.1079965526.squirrel@194.60.85.4>    <Pine.LNX.4.44.0403221748490.13036-100000@coffee.psychology.mcmaster.ca> <39776.194.60.85.4.1080037377.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39776.194.60.85.4.1080037377.squirrel@194.60.85.4>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:

>>why not just experiment and find out?  put two disks on a single channel,
>>make the raid, power down, move the slave to another channel, and see if
>>the raid assembles.
> 
> 
> One word: time; I was hoping someone could tell me if it would work to
> save me messing around. Of course, if I plan to do this I will perform
> some sort of test first.
> 

The answer is yes it will work fine.
I had 5 200gb WD disks set as autodetect raid-5
My internal VIA IDE interfaces were hda/b/c/d
My external CMD680 IDE interfaces were hde/f/g/h

I had raid disks on c/d/e/f/g.
I created the raid and ran it for months, then I shuffled the disks and master/slave jumpers.
No problems.
I then purchased a couple of Highpoint 1540 SATA cards and a bundle of addonics SATA-> IDE adaptors.
Using the in-kernel hpt ata driver, no problem.
I then moved across to a pair of Promise SATA150-TX4 cards with the libata driver, no problem.

So as you can see, these disks have been "everywhere man" and I never had a problem with the kernel 
or appropriate tools picking them up in any order.

Brad
