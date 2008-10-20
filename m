From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 0 md device still active after pulled drive
Date: Mon, 20 Oct 2008 11:21:01 +0200
Message-ID: <gdhiht$ihs$1@ger.gmane.org>
References: <8CAFECFAC51849A-1CD4-454@FWM-D03.sysops.aol.com>
 <18683.53845.702858.972766@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> There is nothing that 'md' can ever do about a failed drive in a
> raid0, so it doesn't bother doing anything.  At all.

Hmmm, would it probably make sense to switch to a fail-stop semantic to
reduce the chance of damaging the rest of the data?
On the other hand... perhaps this is a filesystem-thing to do like
errors=remount-ro does it on ext2.


regards
   Mario
-- 
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

