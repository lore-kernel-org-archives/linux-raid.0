From: "Rainer Fuegenstein" <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: md strange sync?
Date: Fri, 28 May 2010 11:49:44 +0200 (CEST)
Message-ID: <1623.85.233.97.134.1275040184.squirrel@kaneda.iguw.tuwien.ac.at>
References: <609221b5db6a42062f7b353d66e424dd.squirrel@fela.liber4e.com>
    <AANLkTim1JHeU7j8GbXpsvVHr6DmbUlsXX5QFTmHIVbyP@mail.gmail.com>
    <26bd9ee4a9658d4be07cfdc990946ed6.squirrel@fela.liber4e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26bd9ee4a9658d4be07cfdc990946ed6.squirrel@fela.liber4e.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose nuno neto <jose.neto@liber4e.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I have this service running
> /etc/init.d/mdmonitor
> with this command
> mdadm --monitor --scan -f --pid-file=/var/run/mdadm/mdadm.pid
>
> that should be the one, right?

check also /etc/cron.weekly, at least in centos there's a 99-raid-check
script.

what does it mean when this script is running weekly for years at around
04:00 without an noticable activity in the morning, but suddenly it syncs
for about 12hours every week? that something is wrong with the disks?


