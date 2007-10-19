From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 12:44:02 -0400
Message-ID: <18200.57042.989520.666476@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<18200.56684.14194.630264@stoffel.org>
	<Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: John Stoffel <john@stoffel.org>, Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Justin> Is a bitmap created by default with 1.x?  I remember seeing
Justin> reports of 15-30% performance degradation using a bitmap on a
Justin> RAID5 with 1.x.

Not according to the mdadm man page.  I'd probably give up that
performance if it meant that re-syncing an array went much faster
after a crash.

I certainly use it on my RAID1 setup on my home machine.  

John
