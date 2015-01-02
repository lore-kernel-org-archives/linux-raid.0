From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: =?windows-1252?Q?Re=A0=3A_Re=3A_Big_trouble_during_?=
 =?windows-1252?Q?reassemble_a_Raid5?=
Date: Fri, 02 Jan 2015 08:59:39 +0100
Message-ID: <54A64FEB.8090109@gmail.com>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>	<21668.1236.130012.995660@quad.stoffel.home>	<2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>	<21668.8063.635941.184463@quad.stoffel.home>	<A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net>	<21668.12775.212408.482021@quad.stoffel.home>	<480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net>	<21668.19044.575022.311461@quad.stoffel.home>	<1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net> <21670.6532.641717.517799@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21670.6532.641717.517799@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, sylvain.depuille@laposte.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/15 05:07, John Stoffel wrote:
> My real suggestion to you is to now collect all the information you
> can on the system, including drive serial numbers, and how they map to
> each device and member of the RAID array.  Sometimes when a system
> reboots, or you add new disks, things get re-arranged and you don't
> notice at first.  And that leads you down the wrong path quite
> quickly.

Sylvain, a nice script for documenting device serial numbers,
partitions, RAID memberships etc can be found here:

https://github.com/pturmel/lsdrv/raw/master/lsdrv

Written by Phil Turmel; a frequent contributor to this list.

Jan
