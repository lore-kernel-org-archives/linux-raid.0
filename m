From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 16:50:23 +0100
Message-ID: <crovfv$sod$1@sea.gmane.org>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com> <20050108145228.GB26475@janus>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank van Maarseveen <frankvm@frankvm.com> wrote:
> Intriguing setup. Do you think this actually improves the reliability
> with respect to disk failure compared to creating just one large RAID5

Well, there is this one special case where it's a bit more robust:
sector read errors.

> me the odds of losing the entire array won't change (simplified --
> because the increased complexity creates room for additional errors).

You don't do anything else with RAID1 or 5 or whatever: You add
code to reduce the impact of a single disk failure. You add new
points of failure to reduce the impact of other points of failure
there, too.
In this case here, you add code (the RAID0 or LVM code, whatever
you like more) to reduce the impact of two sector read errors on
two disks. Of course the new code can contain new points of
failures. It's as always: know the risk and decide :)


regards,
   Mario
-- 
<jv> Oh well, config
<jv> one actually wonders what force in the universe is holding it
<jv> and makes it working
<Beeth> chances and accidents :)

