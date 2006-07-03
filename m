From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Mon, 3 Jul 2006 11:11:10 +0200
Message-ID: <e8amve$snq$1@sea.gmane.org>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au> <e89kst$8jr$2@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jason Lunz <lunz@falooley.org> wrote:
> there's a udevd you can check for. I don't know whether that's a better
> test or not.

It's not. For example, the Debian package does also start this udevd on
package upgrades, even when a 2.4 kernel is running which definitely
has no udev support :)


regards
   Mario
-- 
Programmieren in C++ haelt die grauen Zellen am Leben. Es schaerft
alle fuenf Sinne: den Schwachsinn, den Bloedsinn, den Wahnsinn, den
Unsinn und den Stumpfsinn.
                                 [Holger Veit in doc]

