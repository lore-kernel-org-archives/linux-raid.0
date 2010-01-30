From: Luca Berra <bluca@comedia.it>
Subject: Re: Array over arrays - how to autoassemble correctly?
Date: Sat, 30 Jan 2010 11:17:36 +0100
Message-ID: <20100130101735.GE15471@maude.comedia.it>
References: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 06:32:57PM +0000, Kristleifur Da=F0ason wrote:
>Hi all,
>
>I'm running a RAID-60 array with mdadm. There are two RAID6 arrays,
>/dev/md/d0 and d1, and then a RAID0 "meta-array" over that,
>/dev/md/tank.
>
>What happens on boot is that the d0 and d1 arrays are assembled, but
>the tank array isn't - Ubuntu drops me to a root shell because it
>couldn't find the tank partition for mounting from fstab. However, I
>just have to do a simple 'mdadm --assemble --scan', and the tank array
>pops up instantly and everything is fine.
>
>How do I instruct mdadm to wait for d0 and d1 and do kind of a second
>assembly pass to construct tank over them?
>
>/proc/mdstat, output of 'mdadm --detail --scan' and
>/etc/mdadm/mdadm.conf are included. I hope that's enough background
>information.

I tested it again, "mdadm --assemble --scan" is able to start stacked
arrays correctly either with a configuration similar to yours or with n=
o
configuration at all !!!
Maybe it is due to how ubuntu tries to assemble your array, i would
guess through udev rules.
Maybe the rules are triggered for real devices (/dev/sd*) and not for
/dev/md*, but im not running ubuntu, so i have no way to know.

Regards,
L.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
