From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm server eating drives
Date: Fri, 14 Jun 2013 17:24:12 -0400
Message-ID: <51BB89FC.8050503@turmel.org>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51B896A2.9090105@websitemanagers.com.au> <CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/14/2013 05:18 PM, Barrett Lewis wrote:

> I'll definatly do this.  When you talk about mismatched timeouts, do
> you mean matched between each of the components (as in
> /sys/block/sdX/device/timeout) or between that driver timeout and some
> device timeout per component?  If you mean between components, are my
> timeouts matched now, even though I did not raise the 30 seconds on
> the two drives with ERC?

For each drive, the driver timeout (/sys/block/.../device/timeout) must
be longer than the drive's timeout (smartctl -l scterc).

Note that scterc is in deciseconds, while the driver uses seconds.

Enterprise drives typically power up with 7.0 second timeouts.  The few
SSDs I've been playing with power up with 4.0 second timeouts.  Without
ERC, the drives I've played with will perform error recovery for about
two full minutes, ignoring the world for the duration.

Phil
