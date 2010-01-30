From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Moved drives between machines... now, MIA.
Date: Fri, 29 Jan 2010 23:27:12 -0800
Message-ID: <4877c76c1001292327i68b3044at245c4f19913475ff@mail.gmail.com>
References: <b54b3e55942c56b2ec1f69d80f54eaea.squirrel@webmail.jots.org>
	 <7d86ddb91001292023x5986f9e6j5d9c2e4e62d5be06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb91001292023x5986f9e6j5d9c2e4e62d5be06@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1) look at your syslog / dmesg to see what auto-detection and initial
tries by your configuration said.
2) You probably want something like I keep as a backup in my
initrd/initramfs images:

/sbin/mdadm --examine --scan /dev/[sh]d* /dev/mapper/* >
/etc/mdadm.conf.OR.SOME.FILE
/sbin/mdadm --assemble --scan --no-degraded
--config=/etc/mdadm.conf.OR.SOME.FILE

If you drop the .OR.SOME.FILE you don't need to specify a non-default
config.  You also don't need to specify any config if you explicitly
name your devices: I'm asking mdadm to examine every block device (and
partition on such) that I think even possibly could be a raid member.
