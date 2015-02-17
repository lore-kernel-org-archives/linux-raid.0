From: Chris <email.bug@arcor.de>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Tue, 17 Feb 2015 07:52:46 +0000 (UTC)
Message-ID: <loom.20150217T080345-764@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb <at> suse.de> writes:

> "maintainers" ? Plural?  That would be nice.
> Unfortunately there is just the one singular me....


Yes, as Weedy said, I also refered to distro package maintainers.

If we can come up here with an udev rule and a script to call, then upstream
(you) could include this, and distro maintainers could make smartctl a
suggested or recommended package of the mdadm package.


I certainly have not understood the whole topic yet,
what I just got is, that the script should do something like
the following, and I found some implementation below.

Evererybody please answer with improved versions if you can.


if smartctl tool is available
  if scterc is disabled
    /usr/sbin/smartctl -l scterc,70,70 ${DEVNAME}
  else
    if screrc is not available
      echo 180 >/sys/block/${DEVNAME}/device/timeout



Found an older implementation that "seems to work fine":

http://article.gmane.org/gmane.linux.raid/44566
>
> contents of udev rule:
> ACTION=="add", SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]",
RUN+="/usr/local/bin/settimeout"
>
>
> contents of /usr/local/bin/settimeout:
> #!/bin/bash
> 
> [ "${ACTION}" == "add" ] && {
>         /usr/sbin/smartctl -l scterc,70,70 ${DEVNAME} || echo 180 >
/sys/${DEVPATH}/device/timeout
> }
> 
> I guess, what is missing, is to connect the HDDs
> with a specific "mdadm" event, instead of running
> for each HDD.
> I'm not sure if this is already possible, since
> some "udev" rules for "md" are already existing.


Let's get this disaster prevention into mdadm, even if just as important
reference experience for solving a more general kernel timeout mismatch
problem "symptom of a more generic issue".
http://article.gmane.org/gmane.linux.raid/44557


