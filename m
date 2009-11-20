From: Faidon Liambotis <paravoid@debian.org>
Subject: Re: Bug#557262: 2.6.31+2.6.31.4: XFS - All I/O
 locks up to D-state after	24-48 hours (sysrq-t+w available) - root cause
 found = asterisk
Date: Sat, 21 Nov 2009 01:44:24 +0200
Message-ID: <4B0729D8.3000105@debian.org>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
Reply-To: Asterisk Users Mailing List - Non-Commercial Discussion
	<asterisk-users@lists.digium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <asterisk-users-bounces@lists.digium.com>
In-Reply-To: <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
List-Unsubscribe: <http://lists.digium.com/mailman/listinfo/asterisk-users>,
	<mailto:asterisk-users-request@lists.digium.com?subject=unsubscribe>
List-Archive: <http://lists.digium.com/pipermail/asterisk-users>
List-Post: <mailto:asterisk-users@lists.digium.com>
List-Help: <mailto:asterisk-users-request@lists.digium.com?subject=help>
List-Subscribe: <http://lists.digium.com/mailman/listinfo/asterisk-users>,
	<mailto:asterisk-users-request@lists.digium.com?subject=subscribe>
Sender: asterisk-users-bounces@lists.digium.com
Errors-To: asterisk-users-bounces@lists.digium.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>, 557262@bugs.debian.org
Cc: linux-raid@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, submit@bugs.debian.org, asterisk-users@lists.digium.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
 > Found root cause-- root cause is asterisk PBX software.  I use an
SPA3102.
> When someone called me, they accidentally dropped the connection, I called
> them back in a short period.  It is during this time (and the last time)
> this happened that the box froze under multiple(!) kernels, always when
> someone was calling.
<snip>
> I don't know what asterisk is doing but top did run before the crash
> and asterisk was using 100% CPU and as I noted before all other processes
> were in D-state.
> 
> When this bug occurs, it freezes I/O to all devices and the only way to
> recover
> is to reboot the system.
That's obviously *not* the root cause.

It's not normal for an application that isn't even privileged to hang
all I/O and, subsequently everything on a system.

This is almost probably a kernel issue and asterisk just does something
that triggers this bug.

Regards,
Faidon

_______________________________________________
-- Bandwidth and Colocation Provided by http://www.api-digital.com --

asterisk-users mailing list
To UNSUBSCRIBE or update options visit:
   http://lists.digium.com/mailman/listinfo/asterisk-users
