From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 01 Feb 2011 15:37:38 -0600
Message-ID: <4D487D22.7090405@hardwarefreak.com>
References: <20110131201823.GA15704@lazy.lzy> <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com> <20110131222348.GA15912@lazy.lzy> <AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com> <20110131230703.GA16834@lazy.lzy> <4D4765B2.7090002@cfl.rr.com> <4D48062E.9040405@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D48062E.9040405@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Phillip Susi <psusi@cfl.rr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson put forth on 2/1/2011 7:10 AM:

> That'd be an excessive amount of time to wait. A quarter of a second is more
> than enough, a tenth of a second would probably be enough. It's just the motor
> inrush current you're trying to avoid having simultaneously.

The blowers in a typical 2U server chassis will have slightly more startup
current draw than the drives, assuming 5 80mm blowers and 8 2.5" drives.  Mobos
don't do staggered startup of blowers.  Thus, staggering the drive spin up is
pointless.  Add to that the fact that most server chassis ship with PSUs large
enough to carry the current draw of anything/everything you can stuff into them.

> So waiting another second for your array to wake up would mean you could use a
> sensibly-sized PSU operating in its 80%+ efficiency range, rather than a huge
> PSU operating inefficiently.

A typical 2.5" 10K RPM 600GB enterprise HDD, such as the Seagate Savvio, has a
startup draw of 24.1 watts combined from the 12v and 5v rails.  A RAID/JBOD
chassis of 24 such drives, which is sold by dozens of vendors today, will draw
only 578.4 watts with all drives spinning up concurrently.  Most such chassis on
the market today are sold with 800w to 1800w redundant PSUs, again, making
staggered spin up moot.

-- 
Stan
