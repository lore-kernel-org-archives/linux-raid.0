From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: raid related... or not ?
Date: Thu, 21 Apr 2005 10:36:13 +0200
Message-ID: <62b0912f0504210136a9363af@mail.gmail.com>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4524@NZURC900PEX1.ubsgs.ubsgroup.net>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E4524@NZURC900PEX1.ubsgs.ubsgroup.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "peter.greis@ubs.com" <peter.greis@ubs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

peter.greis@ubs.com wrote:
> All of this has been tried with both 2.6.8.1 and 2.6.11.7 kernels. At this point I am thinking hardware failure (like the motherboard), but I am looking for opinions. What to try next ?

Make sure that autonegotiation works?
If, for example, your netgear NIC thinks it's running full duplex and
the switch thinks it's running half, you'll probably get packet loss. 
Try forcing both the port on the switch and the network adapter to use
the same speed+duplex setting and see if that works better.

And what have all this got to do with linux-raid?
Nothing?

> Visit our website at http://www.ubs.com
> 
> This message contains confidential information and is intended only
> for the individual named.  If you are not the named addressee you
> should not disseminate, distribute or copy this e-mail.  Please
> notify the sender immediately by e-mail if you have received this
> e-mail by mistake and delete this e-mail from your system.
> 
> E-mail transmission cannot be guaranteed to be secure or error-free
> as information could be intercepted, corrupted, lost, destroyed,
> arrive late or incomplete, or contain viruses.  The sender therefore
> does not accept liability for any errors or omissions in the contents
> of this message which arise as a result of e-mail transmission.  If
> verification is required please request a hard-copy version.  This
> message is provided for informational purposes and should not be
> construed as a solicitation or offer to buy or sell any securities or
> related financial instruments.

Cut the crap when posting to public mailing lists.
