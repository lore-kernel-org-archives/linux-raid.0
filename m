From: =?UTF-8?Q?Tor_Arne_Vestb=C3=B8?= <torarnv@gmail.com>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of
 recovery when one of the failed devices is suspected to be intact?
Date: Sun, 15 Aug 2010 22:06:21 +0200
Message-ID: <AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 15, 2010 at 8:52 PM, Tor Arne Vestb=C3=B8 <torarnv@gmail.co=
m> wrote:
> Hey,
>
> Hoping for some crisis help here :)

Here's a few logs if it helps...

/var/log/messages --> http://pastebin.com/mwny786t

You can see sdb1 being kicked out at some point due to being "non-fresh=
"

dmesg --> http://pastebin.com/073ws32r

/var/log/syslog  --> http://pastebin.com/GarHJD4c

mdadm -E /dev/sd[bcdef]1 --> http://pastebin.com/Kp145Mkx

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
