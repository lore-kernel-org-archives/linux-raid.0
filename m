From: Brett Russ <bruss@netezza.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 17:43:45 -0500
Message-ID: <hj80v1$rap$1@ger.gmane.org>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org> 	<70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com> 	<hj7vta$nvq$1@ger.gmane.org> <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/20/2010 05:30 PM, Majed B. wrote:
> He needs to run a full offline or long test before checking with
> smartctl -a -- since it won't show any sector errors if those tests
> weren't run at least once.

Not sure I agree with that.  The md checks he's been doing will cause a 
read of all data regions of the relevant partition and if the disk is 
throwing errors, those sectors should be marked probational.  Then, if a 
subsequent repair ends up remapping them, those sectors will show up as 
remapped.

The grep will show both probational and remapped sector counts for each 
drive.

BTW, the cmd should also include an echo so it's easy to tell which 
drive is being reported:

for di in a b c d e f g; do echo $di; smartctl -a /dev/sd$di | grep -i 
_sect; done

-BR

