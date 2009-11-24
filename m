From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Which kernel options should be enabled to find the root cause
 of this bug?
Date: Tue, 24 Nov 2009 10:23:26 -0600
Message-ID: <4B0C087E.6050701@sandeen.net>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0911240805490.25676@p34.internal.lan> <4B0BF866.7040004@sandeen.net> <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> On Tue, 24 Nov 2009, Eric Sandeen wrote:

...

>> Do you get the same behavior if you don't add the log options at mount time?
> I have not tried disabling the log options, although they have been in effect
> for a long time, (the logsbufs and bufsize and recently) the nobarrier
> support.  Could there be an issue using -o nobarrier on a raid1+xfs?

nobarrier should not cause problems.

-Eric
