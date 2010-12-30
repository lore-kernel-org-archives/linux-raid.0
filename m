From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 12:59:15 -0500
Message-ID: <AANLkTi=SibZ5vR1WxFTtetGdB1WYZtMn=QaOjmAYAWzz@mail.gmail.com>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
	<alpine.DEB.1.10.1012300623070.27193@uplift.swm.pp.se>
	<AANLkTiksB7D6XwJRE+0oH26U3yz5h--JwmSYcMX+VrCo@mail.gmail.com>
	<20101230214433.7453802a@natsu>
	<AANLkTi=CJstRP5oLJEkBTP+1=9W2LG2DsT+sUhpmxADo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=CJstRP5oLJEkBTP+1=9W2LG2DsT+sUhpmxADo@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/12/30 James <jtp@nc.rr.com>:
>
> Here's what smartctl shows for all of the drives:
>
> ~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep Temperature ;
> done
> 190 Airflow_Temperature_Cel 0x0022 =A0 069 =A0 059 =A0 045 =A0 =A0Old=
_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 31 (Lifetime Min/Max 23/37)
> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 031 =A0 041 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 31 (0 23 0 0)
> 190 Airflow_Temperature_Cel 0x0022 =A0 068 =A0 058 =A0 045 =A0 =A0Old=
_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 32 (Lifetime Min/Max 22/38)
> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 032 =A0 042 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 32 (0 22 0 0)
> 190 Airflow_Temperature_Cel 0x0022 =A0 068 =A0 057 =A0 045 =A0 =A0Old=
_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 32 (Lifetime Min/Max 22/38)
> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 032 =A0 043 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 32 (0 22 0 0)
> 190 Airflow_Temperature_Cel 0x0022 =A0 069 =A0 059 =A0 045 =A0 =A0Old=
_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 31 (Lifetime Min/Max 23/37)
> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 031 =A0 041 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 31 (0 23 0 0)
>
> Those values seem appropriate, particularly since the "max" is 37 (as
> defined by the drive manufacturer?).
>

Not sure why the log is showing the weird C temp. The output from
smartctrl looks correct. The max is not defined by the manufacture,
but the maximum temp the drive has reached.

Ryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
