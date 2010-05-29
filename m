From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: md strange sync?
Date: Fri, 28 May 2010 18:03:13 -0700
Message-ID: <AANLkTimzIq4AhIBxln3221H5SEk-SCZhodiptnqvFj38@mail.gmail.com>
References: <609221b5db6a42062f7b353d66e424dd.squirrel@fela.liber4e.com>
	<AANLkTim1JHeU7j8GbXpsvVHr6DmbUlsXX5QFTmHIVbyP@mail.gmail.com>
	<26bd9ee4a9658d4be07cfdc990946ed6.squirrel@fela.liber4e.com>
	<1623.85.233.97.134.1275040184.squirrel@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1623.85.233.97.134.1275040184.squirrel@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: jose nuno neto <jose.neto@liber4e.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 28, 2010 at 2:49 AM, Rainer Fuegenstein
<rfu@kaneda.iguw.tuwien.ac.at> wrote:
>
>> I have this service running
>> /etc/init.d/mdmonitor
>> with this command
>> mdadm --monitor --scan -f --pid-file=3D/var/run/mdadm/mdadm.pid
>>
>> that should be the one, right?
>
> check also /etc/cron.weekly, at least in centos there's a 99-raid-che=
ck
> script.
>
> what does it mean when this script is running weekly for years at aro=
und
> 04:00 without an noticable activity in the morning, but suddenly it s=
yncs
> for about 12hours every week? that something is wrong with the disks?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Very likely yes.  Check your dmesg / system message log file.

You should also have some way of running SMART tests on the drives on
a regular basis.  I do recall that there was some issue with certain
raid controller chipsets and how they interacted with those commands
in a negative way...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
