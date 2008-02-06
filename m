From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID needs more to survive a power hit, different /boot layout for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Wed, 6 Feb 2008 10:14:33 +0100
Message-ID: <20080206091432.GB19764@percy.comedia.it>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A73F90.3020307@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A73F90.3020307@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 04, 2008 at 07:38:40PM +0300, Michael Tokarev wrote:
>Eric Sandeen wrote:
>[]
>> http://oss.sgi.com/projects/xfs/faq.html#nulls
>> 
>> and note that recent fixes have been made in this area (also noted in
>> the faq)
>> 
>> Also - the above all assumes that when a drive says it's written/flushed
>> data, that it truly has.  Modern write-caching drives can wreak havoc
>> with any journaling filesystem, so that's one good reason for a UPS.  If
>
>Unfortunately an UPS does not *really* help here.  Because unless
>it has control program which properly shuts system down on the loss
>of input power, and the battery really has the capacity to power the
>system while it's shutting down (anyone tested this?  With new UPS?
>and after an year of use, when the battery is not new?), -- unless
>the UPS actually has the capacity to shutdown system, it will cut
>the power at an unexpected time, while the disk(s) still has dirty
>caches...
>
if the ups is supported by nut (http://www.networkupstools.org) you can
do this easily.
Obviously you should tune the timeout to give your systems enough time
to shutdown in case of power outage, and periodically check your
battery duration (that means real tests) and re-tune the nut software
(and when you discover your battery is dead, change it)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
