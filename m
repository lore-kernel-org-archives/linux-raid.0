From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: monitoring means for IBM ServeRAID driver?
Date: Mon, 30 Jun 2003 18:18:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030630161835.GO12240@marowsky-bree.de>
References: <bWpzdHVtcGY=.f03bfc26e5230960f5f182cfeb610c52@1056989708.cotse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bWpzdHVtcGY=.f03bfc26e5230960f5f182cfeb610c52@1056989708.cotse.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-06-30T12:15:08,
   mjstumpf <mjstumpf@cotse.net> said:

> Is there some "trivial" means ("cat /proc/mdstat" or its equivalent i=
n
> mdadm) of monitoring the health of a raid constructed via IBM ServeRA=
ID?=20
> The RAID appears to linux as a opaque, very large scsi device.

Maybe this information tidbit can help you:

#       As of this writing (5/22/2003) this version of the software is =
not
#       yet available.  For everything but the ipssend command, you can
#       grab the ISO image here:
#
#               ftp://ftp.pc.ibm.com/pub/pccbbs/bp_server/01r0539.iso
#
#       For the time being, you will need to grab a "correct" version o=
f
#       the ipssend command here:
#               http://linux-ha.org/download/ipssend.gz

(It's from a heartbeat resource script controlling ServeRAID failover)

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
