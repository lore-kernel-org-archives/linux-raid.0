From: Phil Turmel <philip@turmel.org>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Fri, 03 Aug 2012 09:36:38 -0400
Message-ID: <501BD3E6.6050004@turmel.org>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com> <20120802091917.32fb0ca5@natsu> <501A316C.3020305@hardwarefreak.com> <20120802140634.6f729d07@natsu> <1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com> <501AB9D8.1030404@turmel.org> <1343932322.14845.140661109934445.709DABBB@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1343932322.14845.140661109934445.709DABBB@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: listy@fastmail.fm
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

I now see that I hit the wrong "reply" button--my apologies to the list.
 You've quoted the important stuff, though, so I won't resend.

On 08/02/2012 02:32 PM, listy@fastmail.fm wrote:
> On Thu, Aug 2, 2012, at 13:33, Phil Turmel wrote:
>> You really do need to have a process check mismatch_cnt after your
>> weekly check completes.
> 
> 
> With Fedora, I get an email Monday morning, after the raid-check, which 
> warns of a non-zero mismatch_cnt.

Good to know.  I'm on gentoo, and I use my own script in logwatch, so
I'm not familiar with the various distros practice on this.

>> Depends.  If you use "repair", bad data will be propagated.  If you use
>> "check", it'll just be reported.
> 
> 
> Ah, okay, good.  I thought I'd read here a while back that "check" & 
> "repair" do the same thing.
> 
> 
>> I've seen a great deal of good advice here, but nothing about the system
>> component least likely to be protected in an "economy" system:
>> RAM.  Does your Mobo have ECC ram?  
> 
> Good point.  It does not.  Might be time for me to upgrade to a mobo with 
> ECC support.

In my opinion, any corruption noticed in a non-ECC system is most likely
due to the RAM.  You really need to run memtest86 on your system,
preferably for 24 hours or more.

>> does your kernel support logging, and are you monitoring the
>> machine check log?
> 
> klogd is not running, but I think the latest rsyslog handles the kernel 
> messages.  There was nothing in the logs related to my corruption issues, 
> however.

I meant logging of ECC RAM correction events (warnings) and
uncorrectable errors.  Your kernel has to support that.  I would be
shocked if Fedora didn't support it.  You also need the user space
"mcelog" package.  "mce" ==> "Machine Check Exception"

>> Hard drives write extensive ECC payloads to catch corruptions there;
>> SATA and SAS protocols have CRC checks on every frame transferred; the
>> PCIe bus uses CRC checks on each lane, with low-level encoding very
>> similar to SATA.  Even modern processors are using PCIe-style encoded
> 
> Thanks, this is good info, and kind of gets at my thinking when I posted my 
> initial question.  In a typical consumer hardware setup, with a current 
> linux kernel, do I have to take any steps to enable these kinds of checks?
> Can the kernel log any failed checks at the levels you mention?  I guess my 
> confusion with my silent data corruption issues stems from my naive 
> assumption that all the various data transfers happening would have some 
> way of detecting or flagging the bad reads as they happened.

You won't get ram corruption error reports if you don't have ECC ram.
Data transfer errors between CPU and chipset might generate machine
check exceptions, but if not recoverable, the machine just dies.  Errors
on PCIe lanes and SATA/SAS connections cause retransmissions until
success or the driver times out.  That would show up in dmesg.

> But maybe as you suggest, my issue is related to memory, and ECC might help 
> in the future?

You don't have to guess.  Boot into memtest86 and see.  And yes, any
machine handling data you really care about should have ECC ram.

Phil
