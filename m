From: Nix <nix@esperi.org.uk>
Subject: Re: Linux RAID version question
Date: Sun, 26 Nov 2006 23:51:52 +0000
Message-ID: <87vel1wyuf.fsf@hades.wkstn.nix>
References: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
	<981224FF5B88B349B7C1FED584D2620E07328A52@CORPUSMX50B.corp.emc.com>
	<d33135570611242354l74e383b7r37bdd8c81c001672@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d33135570611242354l74e383b7r37bdd8c81c001672@mail.gmail.com> (Dragan Marinkovic's message of "25 Nov 2006 07:58:19 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Dragan Marinkovic <marinkovic.dragan@gmail.com>
Cc: "Foster_Brian@emc.com" <Foster_Brian@emc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 Nov 2006, Dragan Marinkovic stated:
> Hm, I was playing with RAID 5 with one spare (3 + 1) and metadata
> version 1.2 . If I let it build to some 10% and cleanly reboot it does
> not start where it left off -- basically it starts from scratch. I was
> under the impression that RAID with metadata version 1.x exhibits
> different behavior with kernel 2.6.18 . I'm staring the array as:
>
>        /sbin/mdadm --assemble --scan -e 1.2 --no-degraded
> --config=/etc/mdadm.conf
>
> On another topic, I looked through the code trying to find if metadata
> version can be stored as a default in conf file. Unfortunately, there
> is no such option. It would be nice to have it so you don't have to
> specify it when assembling the array.

Well, I assemble my arrays with the command

    /sbin/mdadm --assemble --scan --auto=md

and mdadm.conf looks like

DEVICE partitions
ARRAY /dev/md0 UUID=3a51b74f:8a759fe7:8520304c:3adbceb1
ARRAY /dev/md1 UUID=a5a6cad4:2c7fdc07:88a409b9:192ed3bf
ARRAY /dev/md2 UUID=fe44916d:a1098576:8007fb81:2ee33b5a

MAILADDR postmaster@esperi.org.uk


No metadata versions needed anywhere.

-- 
`The main high-level difference between Emacs and (say) UNIX, Windows,
 or BeOS... is that Emacs boots quicker.' --- PdS
