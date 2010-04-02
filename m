From: Luca Berra <bluca@comedia.it>
Subject: responsiveness during raid check (Was: Problems with RAID 6 across
	15 disks)
Date: Fri, 2 Apr 2010 07:55:08 +0200
Message-ID: <20100402055508.GA15102@maude.comedia.it>
References: <4BB49E4D.1090809@maxeaves.co.uk> <4BB4A461.5030704@redhat.com> <4BB4A89F.7030707@maxeaves.co.uk> <20100402074325.3ce34e8f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100402074325.3ce34e8f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 02, 2010 at 07:43:25AM +1100, Neil Brown wrote:
>On Thu, 01 Apr 2010 15:07:27 +0100
>Max Eaves <max@maxeaves.co.uk> wrote:
>
>> Doug,
>> 
>> Thank you very much for that; a great relief off my shoulders.
>> 
>> You are right - there is a config file located in 
>> /etc/sysconfig/raid-check.  I've changed ENABLED to no.
>
>However there is real value in doing that check, at least occasionally.  It
>catches latent read errors.
>
>You might want to run it only every couple of months, and you might want to
>wind down one of both of the /proc/sys/dev/raid/speed_limit_* numbers so
>there is minimal impact on your system.
>
sorry if i am hijacking, but i got a report from one user that the
scheduled scrubbing is severely impacting responsiveness, lowering the
speed_limits seems to help a bit, but he reports it is still sluggish, 
i always believed the check should use idle time, and not impact
performance that much. could it be scheduler related?

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
