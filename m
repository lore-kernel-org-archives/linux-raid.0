From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5+1 with mdadm
Date: Wed, 15 Sep 2010 17:52:57 -0500
Message-ID: <4C914E49.6030201@hardwarefreak.com>
References: <S1754030Ab0IOUpu/20100915204550Z+730@vger.kernel.org> <4C913973.60007@saocarlos.sp.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C913973.60007@saocarlos.sp.gov.br>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Krauss put forth on 9/15/2010 4:24 PM:
> Hello,
> 
> I am looking for a "step by step" webpage (or replied attach) for setup
> RAID 5+1

You probably won't find one, unless someone writes one just for you.
RAID 5+1 is very non-standard.  In fact I've never heard of anyone using
it, only as a theoretical possibility.  RAID 50, or 5+0, is far more
common, and it itself is not very common overall.

Your goal will require nesting of RAID groups--nesting of md devices.
You're going to need to create two RAID5 md devices and then make a
RAID1 device from the two RAID5 devices.  If you already know how to
create a RAID5 md device and a RAID1 md device, this should be a piece
of cake.

Keep the mdadm man page open while you do it just in case.  The only
thing you really need to be concerned with are the chunk and stripe
sizes, which can get complicated when creating nested arrays.  I have no
idea what those parms should be for a 6 disk nested RAID5/1.  Maybe
someone here can help.

Good luck.

-- 
Stan
