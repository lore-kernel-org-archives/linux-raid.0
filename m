From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: mdadm.conf on Ubuntu - it's alive!
Date: Tue, 4 Sep 2012 01:02:10 +0100
Message-ID: <CANBHLUjc-xn1P5tTqEUVaXJ3iqmsbtS7c5Z=fOGbzDHSNH6DPw@mail.gmail.com>
References: <1E8511BEA626CC42AD82C5723921D7E1298E01@LW-MBX1.us.logicworks.net>
	<1E8511BEA626CC42AD82C5723921D7E1299124@LW-MBX1.us.logicworks.net>
	<1E8511BEA626CC42AD82C5723921D7E129913F@LW-MBX1.us.logicworks.net>
	<1E8511BEA626CC42AD82C5723921D7E129A554@LW-MBX1.us.logicworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1E8511BEA626CC42AD82C5723921D7E129A554@LW-MBX1.us.logicworks.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gilbert Standen <gstanden@logicworks.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!

On 4 September 2012 00:19, Gilbert Standen <gstanden@logicworks.net> wrote:
> Hi All,
>
> I don't have a burning question per se, but I wanted to share something and also ask a question related to it.  I was having this problem on Ubuntu 12.04 where the raid would keep trying to build at md127 instead of md0 (as-built).  I should add that before doing the following steps, it was a guessing game on each reboot if things would start ok.  I regularly got messages during boot about "HDIO_IDENTITY_FAILED" and sometimes messages about degraded raid array during bootup.  Not absolutely sure about cause and effect there, but the following completely and totally ended all these problems:
> guess VGER won't allow me to include here it keeps bouncing my post back - let me know if you need it)
>
> I read a URL post that suggested the following might fix my problems so I did it:
>
>  1076  mdadm --examine --scan --config=mdadm.conf >> /etc/mdadm/mdadm.conf
>  1077  cd /etc/mdadm
>  1078  vi mdadm.conf
>  1079  sudo update-initramfs -u
>
> Ever since sweet!  all runs like the railroad now.
>
> Now here's the question part.  Here's my current mdadm.conf:
>
> root@Ubuntu1204:~# cat /etc/mdadm/mdadm.conf
> DEVICE partitions
> DEVICE /dev/raiddisk1 /dev/raiddisk2 /dev/raiddisk3
> ARRAY /dev/md0 metadata=1.2 UUID=8a14ee9a:ca0c3a48:51931b2a:338fee9d
> MAILADDR root
> ARRAY /dev/md/0 metadata=1.2 UUID=8a14ee9a:ca0c3a48:51931b2a:338fee9d name=Ubuntu1204:0
>

It looks like the hostname of your array was set to Ubuntu1204 when
you created the array.
While the hostname on your machine is now different.
Therefore the array was getting assembled as 127 instead of 0.

Did you, perhaps, follow some kind of a guide to create the array from
the LiveCD instead of using alternative / debian-installer?
In either case I would be interested in seeing the logs.

This is nothing to do with linux-raid upstream, but it is Ubuntu
integration specific bug.

Please file bugs using:

$ ubuntu-bug mdadm
$ ubuntu-bug ubiquity (if you installed using live cd installer)
$ ubuntu-bug debian-installer (if you used pxeboot, alternative,
netboot or mini ISOs)


> I'm not changing it because everything is working so flawlessly, but mira : those last 2 lines I did not put in and they were not in there when I ran my commands above (the MAILADDR line and the 2nd ARRAY line).  I would not have guessed that everything would run so great with 2 different no less ARRAY lines in the mdadm.conf but my system seems to really love this mdadm.conf the way rivers love to flow.
>
> Wondering if anyone can explain how the other 2 lines got in there, why the mdadm.conf works ok with 2 ARRAY lines and any other nuggets of info.
>
> thanks Gil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,

Dmitrijs.
