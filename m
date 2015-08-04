From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID1 degraded
Date: Tue, 04 Aug 2015 08:56:08 -0700
Message-ID: <55C0E098.7000404@tigertech.com>
References: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com> <55BFFDD3.5000005@websitemanagers.com.au> <478DB4ED-9FAB-4035-A482-0BC11046B6C2@me.com> <55C0409E.5010004@websitemanagers.com.au> <14A646FC-54F8-4A2E-978D-49800FB534CF@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14A646FC-54F8-4A2E-978D-49800FB534CF@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/3/15 10:55 PM, Hans Malissa wrote:

> Rebooting the system didn=E2=80=99t solve the problem, /dev/sdc is st=
ill nowhere to be found.=20

Possible tip: I've seen several cases where rebooting was not enough to
make a failed drive visible. In some cases, power actually needs to be
removed from the server for a few seconds (or the drive needs to be
removed and reinserted if it's hot-swap capable).

That's because the drive software itself may be hung in a way that only
gets fixed when power is removed from, then restored to, the drive.

--=20
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
