From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 15:34:48 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE78458.4411C4B5@SteelEye.com>
References: <02d201c33023$13fd45a0$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ionut Nistor <ionut@modulo.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ionut Nistor wrote:

> I'm using a 2.4.18-ac3 kernel 

It just dawned on me that this kernel probably does not have the
following patch applied:

http://lwn.net/Articles/8485/

If that's the case, you may want to move to a later kernel or apply that
patch. I believe the patch will fix your issues with the shifting minor
numbers causing problems. 

I did a brief test on SuSE's 2.4.19 kernel, which has this patch
applied, and everything worked, even after shifting devices around.

--
Paul
