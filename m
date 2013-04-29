From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
Subject: Mdadm monitor sometimes doesn't send events.
Date: Mon, 29 Apr 2013 10:52:57 +0200
Message-ID: <517E34E9.3050602@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,
We've got a problem that sometimes mdadm monitor doesn't send events.=20
Actions are as follows:

start:
create new RAID 5 array
wait until it's rebuilding
stop created array
go to start

Only first time we get "NewArray" event then when new array is created=20
only "RebuildStarted" event appears. After our analysis we found out=20
that when we stop an array we get "DeviceDisapeared" event and when we=20
create a new array we get "RebuildFinished" and then "RebuildStarted"=20
event. Sometimes those two events don't show up.
The problem is in mdstat_read function:

else if (ent->percent =3D=3D -1 && w[0] >=3D '0' && w[0] <=3D '9' && w[=
l-1] =3D=3D=20
'%') {
     ent->percent =3D atoi(w);
}

atoi(w) sometimes returns 0 instead -1. It causes that mse->percent =3D=
 0 in:

             if (mse &&
                 mse->percent =3D=3D -1 &&
                 st->percent >=3D 0)
                 alert("RebuildFinished", dev, NULL, mailaddr, mailfrom=
,=20
alert_cmd, dosyslog);

and above conditions aren't met. Then in:

             if (mse)
                 st->percent =3D mse->percent;

st->percent becomes 0 and next conditions where "RebuildStarted" event=20
should be sent also aren't met:
             if (mse &&
                 st->percent =3D=3D -1 &&
                 mse->percent >=3D 0)
                 alert("RebuildStarted", dev, NULL, mailaddr, mailfrom,=
=20
alert_cmd, dosyslog);

Probably it is fine because rebuild already started and this is what=20
monitor reads from /proc/mdstat. Shouldn't it return "NewArray" event=20
instead those two "RebuildFinished" and "RebuildStarted" in this situat=
ion?

We use mdadm version 2.5.6 and monitor runs as a daemon with 10s=20
interval and scan option.

Do we need to restart mdadm monitor when new disk is added to the syste=
m=20
(hotplug)? Do we need to generate config file in such situation or=20
running mdadm with option --scan is sufficient?

--=20
Best regards
Arkadiusz Buba=C5=82a
Open-E Poland Sp. z o.o.
www.open-e.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
