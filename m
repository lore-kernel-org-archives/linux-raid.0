From: Luca Berra <bluca@comedia.it>
Subject: Re: announce: tiny raidtools-alike for use e.g. in initrd
Date: Fri, 31 Oct 2003 10:16:27 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031031091626.GD26757@percy.comedia.it>
References: <3FA0BCD1.1060003@tls.msk.ru> <20031031084320.GC26757@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031031084320.GC26757@percy.comedia.it>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

/me should drink more coffee in the morning
heres the patch: (it is vs 1.3.0, but it applies on 1.4.0 as well)

On Fri, Oct 31, 2003 at 09:43:21AM +0100, Luca Berra wrote:
>well, 
>since it is announce week :)))
>
>I made a small patch to mdadm to build a subset of mdadm with diet-libc,
>for use in initrds. (it is 44k statically linked)
>
>I cannot rebuild whole mdadm with dietlibc due to dietlibc not
>understanding non option arguments beetween option (optarg starting
>with "-")
>
>to build use:
>diet gcc -DCONFFILE="\"/etc/mdadm.conf\"" -o mdassemble \
>        mdassemble.c Assemble.c config.c dlink.c util.c
>
>mdassemble will just scan /etc/mdadm.conf and try to assemble everything
>it finds like running "mdadm -A -s".
>

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--YZ5djTAD1cGYuMQK
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="mdadm-1.3.0-diet.diff.bz2"
Content-Transfer-Encoding: base64

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
3cI=

--YZ5djTAD1cGYuMQK--
