From: Phil Turmel <philip@turmel.org>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 11:11:32 -0400
Message-ID: <517FDF24.9000807@turmel.org>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch> <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se> <517FD7BE.8040401@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517FD7BE.8040401@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/30/2013 10:39 AM, Roberto Nunnari wrote:
> Mikael Abrahamsson wrote:
>> On Tue, 30 Apr 2013, Roberto Nunnari wrote:
>>
>>> How do I increase that timeout?
>>
>> for x in /sys/block/sd[a-z] ; do echo 180  > $x/device/timeout ; done
> 
> what the... these are SECONDS! What on earth could delay a sata attached
> disk read for 30 (now 180) seconds if not a disk failure? I OS hang?
> Sorry about that question, but I don't understand.. I have never seen
> such a problem.

The worst horror stories on this mailing list are directly attributable
to this problem.  Usually after months or even years of apparently
trouble-free operation.

Consumer-grade drives intended for desktop usage are not
"out-of-the-box" compatible with RAID.  Some of them are configurable
after each power-up to behave like an enterprise drive.  The rest must
be accommodated with extended driver timeouts.

Search the list archives for "scterc", "timeout", and "URE" (or
combinations thereof).

Phil


