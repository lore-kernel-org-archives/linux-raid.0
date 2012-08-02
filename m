From: listy@fastmail.fm
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 02 Aug 2012 14:32:02 -0400
Message-ID: <1343932322.14845.140661109934445.709DABBB@webmail.messagingengine.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com>
 <20120802091917.32fb0ca5@natsu> <501A316C.3020305@hardwarefreak.com>
 <20120802140634.6f729d07@natsu>
 <1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
 <501AB9D8.1030404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501AB9D8.1030404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 2, 2012, at 13:33, Phil Turmel wrote:
> You really do need to have a process check mismatch_cnt after your
> weekly check completes.


With Fedora, I get an email Monday morning, after the raid-check, which 
warns of a non-zero mismatch_cnt.


> Depends.  If you use "repair", bad data will be propagated.  If you use
> "check", it'll just be reported.


Ah, okay, good.  I thought I'd read here a while back that "check" & 
"repair" do the same thing.


> I've seen a great deal of good advice here, but nothing about the system
> component least likely to be protected in an "economy" system:
> RAM.  Does your Mobo have ECC ram?  

Good point.  It does not.  Might be time for me to upgrade to a mobo with 
ECC support.


> does your kernel support logging, and are you monitoring the
> machine check log?

klogd is not running, but I think the latest rsyslog handles the kernel 
messages.  There was nothing in the logs related to my corruption issues, 
however.

> Hard drives write extensive ECC payloads to catch corruptions there;
> SATA and SAS protocols have CRC checks on every frame transferred; the
> PCIe bus uses CRC checks on each lane, with low-level encoding very
> similar to SATA.  Even modern processors are using PCIe-style encoded

Thanks, this is good info, and kind of gets at my thinking when I posted my 
initial question.  In a typical consumer hardware setup, with a current 
linux kernel, do I have to take any steps to enable these kinds of checks?
Can the kernel log any failed checks at the levels you mention?  I guess my 
confusion with my silent data corruption issues stems from my naive 
assumption that all the various data transfers happening would have some 
way of detecting or flagging the bad reads as they happened.

But maybe as you suggest, my issue is related to memory, and ECC might help 
in the future?

Thanks,
matt
