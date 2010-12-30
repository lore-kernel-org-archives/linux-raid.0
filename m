From: James <jtp@nc.rr.com>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 11:51:51 -0500
Message-ID: <AANLkTi=CJstRP5oLJEkBTP+1=9W2LG2DsT+sUhpmxADo@mail.gmail.com>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
 <alpine.DEB.1.10.1012300623070.27193@uplift.swm.pp.se> <AANLkTiksB7D6XwJRE+0oH26U3yz5h--JwmSYcMX+VrCo@mail.gmail.com>
 <20101230214433.7453802a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230214433.7453802a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 30, 2010 at 11:44, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 30 Dec 2010 11:33:31 -0500
> James <jtp@nc.rr.com> wrote:
>
>> Dec 20 17:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
>> Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
>>
>> Is it normal for SMART to update the attributes as the drives are
>> being used? (I've never had SMART installed before, so this is all
>> very new to me).
>
> If your drives run at 68 degrees Celsius, you should emergency-cut the power
> ASAP and perhaps reach for the nearest fire extinguisher.

Agreed. ;) That's why I posted those messages -- I'm unsure why it
would change those values.

Here's what smartctl shows for all of the drives:

~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep Temperature ;
done
190 Airflow_Temperature_Cel 0x0022   069   059   045    Old_age
Always       -       31 (Lifetime Min/Max 23/37)
194 Temperature_Celsius     0x0022   031   041   000    Old_age
Always       -       31 (0 23 0 0)
190 Airflow_Temperature_Cel 0x0022   068   058   045    Old_age
Always       -       32 (Lifetime Min/Max 22/38)
194 Temperature_Celsius     0x0022   032   042   000    Old_age
Always       -       32 (0 22 0 0)
190 Airflow_Temperature_Cel 0x0022   068   057   045    Old_age
Always       -       32 (Lifetime Min/Max 22/38)
194 Temperature_Celsius     0x0022   032   043   000    Old_age
Always       -       32 (0 22 0 0)
190 Airflow_Temperature_Cel 0x0022   069   059   045    Old_age
Always       -       31 (Lifetime Min/Max 23/37)
194 Temperature_Celsius     0x0022   031   041   000    Old_age
Always       -       31 (0 23 0 0)

Those values seem appropriate, particularly since the "max" is 37 (as
defined by the drive manufacturer?).

> --
> With respect,
> Roman
