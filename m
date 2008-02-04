From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
  for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Tue, 05 Feb 2008 08:02:04 +1300
Message-ID: <47A7612C.4070507@sauce.co.nz>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A73F90.3020307@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A73F90.3020307@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev wrote:

> Unfortunately an UPS does not *really* help here.  Because unless
> it has control program which properly shuts system down on the loss
> of input power, and the battery really has the capacity to power the
> system while it's shutting down (anyone tested this?  With new UPS?
> and after an year of use, when the battery is not new?), -- unless
> the UPS actually has the capacity to shutdown system, it will cut
> the power at an unexpected time, while the disk(s) still has dirty
> caches...

I'm unsure what you mean here. The Network UPS Tools project
http://www.networkupstools.org/ has been supplying software to do this
for years.

In addition, a number of UPS manufacturers including APC, one of the
larger ones, provide Linux management and monitoring software with the UPS.

As far as worrying whether a one year old battery has enough capacity to
hold up while the system shuts down, there is no reason why you cannot
set it to shut the system down gracefully after maybe 30 seconds of
power loss if you feel it is necessary.

A reputable brand UPS with a correctly sized battery capacity will have
no trouble in this scenario unless the battery is faulty, in which case
it will probably be picked up during automated load tests. As long as
the manufacturers battery replacement schedule is followed, genuine
replacement batteries are used and automated regular UPS tests are
enabled, the risks of failure are small.

Regards,

Richard


