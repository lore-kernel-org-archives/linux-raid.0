From: Luca Berra <bluca@comedia.it>
Subject: Re: Minor mdadm fixes
Date: Fri, 19 Mar 2010 08:01:53 +0100
Message-ID: <20100319070153.GA12455@maude.comedia.it>
References: <4BA2DDB2.2040508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BA2DDB2.2040508@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 18, 2010 at 10:13:06PM -0400, Doug Ledford wrote:
>Second: mdadm-3.1.2-mapfile.patch
>Problem: Neil's support for putting the mdadm map file wherever you need
>it is nice, but one place in particular needs a special case.
>Specifically, mdadm already creates /dev/md if needed to store symlinks,
>or in the case of mdmon needing to create pid/sock files (if ALT_RUN is
why on earth do you want to set ALT_RUN=/dev/md ?
it is messy enough as it is, let's keep assuming /dev/md contains only
array device files.

besides that you will discover that the only way to make mdmon work is 
setting VAR_RUN and ALT_RUN to the same value, something we can
guarantee to be writable even in the direst situation, and i'd keep
/dev/.mdadm

>Fourth: mdadm-3.1.2-mapname.patch
>Feature: If we are able to easily select the location of the mapfile via
>the use of ALT_RUN at compile time, it makes sense to also be able to
this "hunt the mapfile" thing is already ugly as it is, why do we need
an ALT_MAPNAME? if there was any value (except for allowing to set
ALT_RUN to /dev/md) to having the mapfile named differently, just force
it to be called mdadm.map everywere (or incremental.map so the name
reflects the need for the file existance)

L.



-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
