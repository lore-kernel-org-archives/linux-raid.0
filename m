From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 20:42:13 -0700
Message-ID: <nrd5ak$e8c$1@blaine.gmane.org>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org>
 <20160914232249.6e5fc568@natsu> <nrce27$2km$1@blaine.gmane.org>
 <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com>
 <nrckp2$k8e$1@blaine.gmane.org>
 <CAJCQCtQ1GHdQtShbW3U1o-fmXhT3fHrC7S9BxsxrrOG=0H_p3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJCQCtQ1GHdQtShbW3U1o-fmXhT3fHrC7S9BxsxrrOG=0H_p3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Chris Murphy wrote on 09/14/2016 04:15 PM:
>it
> ought to work.

i had this happen the other day:

Sep 12 05:57:01 hind kernel: [1342342.663516] RAID conf printout:
Sep 12 05:57:01 hind kernel: [1342342.663528]  --- level:5 rd:11 wd:11
Sep 12 05:57:01 hind kernel: [1342342.663535]  disk 0, o:1, dev:sdb1
Sep 12 05:57:01 hind kernel: [1342342.663540]  disk 1, o:1, dev:sdc1
Sep 12 05:57:01 hind kernel: [1342342.663544]  disk 2, o:1, dev:sdd1
Sep 12 05:57:01 hind kernel: [1342342.663548]  disk 3, o:1, dev:sde1
Sep 12 05:57:01 hind kernel: [1342342.663552]  disk 4, o:1, dev:sdf1
Sep 12 05:57:01 hind kernel: [1342342.663556]  disk 5, o:1, dev:sdg1
Sep 12 05:57:01 hind kernel: [1342342.663560]  disk 6, o:1, dev:sdh1
Sep 12 05:57:01 hind kernel: [1342342.663564]  disk 7, o:1, dev:sdi1
Sep 12 05:57:01 hind kernel: [1342342.663568]  disk 8, o:1, dev:sdj1
Sep 12 05:57:01 hind kernel: [1342342.663572]  disk 9, o:1, dev:sdk1
Sep 12 05:57:01 hind kernel: [1342342.663576]  disk 10, o:1, dev:sdl1
Sep 12 05:57:01 hind kernel: [1342342.663735] md: data-check of RAID 
array md0
Sep 12 05:57:01 hind kernel: [1342342.663751] md: minimum _guaranteed_ 
speed: 1000 KB/sec/disk.
Sep 12 05:57:01 hind kernel: [1342342.663757] md: using maximum 
available idle IO bandwidth (but not more than 200000 KB/sec) for 
data-check.
Sep 12 05:57:01 hind kernel: [1342342.663793] md: using 128k window, 
over a total of 976629760k.
Sep 12 08:05:29 hind kernel: [1350045.526546] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:29 hind kernel: [1350045.527460] sd 3:0:1:0: [sdk] 
Unhandled sense code
Sep 12 08:05:29 hind kernel: [1350045.527478] sd 3:0:1:0: [sdk]
Sep 12 08:05:29 hind kernel: [1350045.527485] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Sep 12 08:05:29 hind kernel: [1350045.527492] sd 3:0:1:0: [sdk]
Sep 12 08:05:29 hind kernel: [1350045.527499] Sense Key : Medium Error 
[current]
Sep 12 08:05:29 hind kernel: [1350045.527512] Info fld=0x23abbe32
Sep 12 08:05:29 hind kernel: [1350045.527518] sd 3:0:1:0: [sdk]
Sep 12 08:05:29 hind kernel: [1350045.527525] Add. Sense: Unrecovered 
read error
Sep 12 08:05:29 hind kernel: [1350045.527532] sd 3:0:1:0: [sdk] CDB:
Sep 12 08:05:29 hind kernel: [1350045.527537] Read(10): 28 00 23 ab bc 
c8 00 04 00 00
Sep 12 08:05:29 hind kernel: [1350045.527554] end_request: critical 
medium error, dev sdk, sector 598457896
Sep 12 08:05:34 hind kernel: [1350051.022308] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:34 hind kernel: [1350051.022524] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:34 hind kernel: [1350051.022745] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:34 hind kernel: [1350051.022969] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:34 hind kernel: [1350051.023190] mptbase: ioc1: 
LogInfo(0x31080000): Originator={PL}, Code={SATA NCQ Fail All Commands 
After Error}, SubCode(0x0000) cb_idx mptscsih_io_done
Sep 12 08:05:34 hind kernel: [1350051.023743] sd 3:0:1:0: [sdk] 
Unhandled sense code
Sep 12 08:05:34 hind kernel: [1350051.023772] sd 3:0:1:0: [sdk]
Sep 12 08:05:34 hind kernel: [1350051.023779] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Sep 12 08:05:34 hind kernel: [1350051.023786] sd 3:0:1:0: [sdk]
Sep 12 08:05:34 hind kernel: [1350051.023792] Sense Key : Medium Error 
[current]
Sep 12 08:05:34 hind kernel: [1350051.023806] Info fld=0x23abbe32
Sep 12 08:05:34 hind kernel: [1350051.023813] sd 3:0:1:0: [sdk]
Sep 12 08:05:34 hind kernel: [1350051.023819] Add. Sense: Unrecovered 
read error
Sep 12 08:05:34 hind kernel: [1350051.023826] sd 3:0:1:0: [sdk] CDB:
Sep 12 08:05:34 hind kernel: [1350051.023830] Read(10): 28 00 23 ab be 
28 00 00 80 00
Sep 12 08:05:34 hind kernel: [1350051.023847] end_request: critical 
medium error, dev sdk, sector 598457896
Sep 12 08:05:35 hind kernel: [1350051.385810] md/raid:md0: read error 
corrected (8 sectors at 598455848 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385826] md/raid:md0: read error 
corrected (8 sectors at 598455856 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385834] md/raid:md0: read error 
corrected (8 sectors at 598455864 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385840] md/raid:md0: read error 
corrected (8 sectors at 598455872 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385847] md/raid:md0: read error 
corrected (8 sectors at 598455880 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385853] md/raid:md0: read error 
corrected (8 sectors at 598455888 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385859] md/raid:md0: read error 
corrected (8 sectors at 598455896 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385865] md/raid:md0: read error 
corrected (8 sectors at 598455904 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385873] md/raid:md0: read error 
corrected (8 sectors at 598455912 on sdk1)
Sep 12 08:05:35 hind kernel: [1350051.385880] md/raid:md0: read error 
corrected (8 sectors at 598455920 on sdk1)
Sep 12 13:39:43 hind kernel: [1370087.022160] md: md0: data-check done.


so it seems to be working?  although the sector reported by libata is 
different than what md corrected

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
