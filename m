From: Roberto Spadim <roberto@spadim.com.br>
Subject: raid1 mirror optimizations
Date: Tue, 25 Jan 2011 16:56:04 -0200
Message-ID: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys... i have a damaged disk...
i=B4m using raid1
the computer crashed with the floor :P hihiih sorry, but the disks are
damaged at the same position
check: http://www.spadim.com.br/hd%20agra.zip
the problem: since raid1 (mirror) is done with real mirror, the disk
position are the same...
if i was using a mirror but on disk 1 i write from beggining to end,
and disk 2 from end to beggining , i don=B4t crash the disk at the same
position, for disk 1 i crash it some bytes, for disk 2 i crash some
others bytes, since beggining is a small cilinder and end a bigger, i
could loose less information than mirror
could we implement a 'inverted' mirror? just for hard disks (for ssd
it=B4s a small loss of cpu/memory)
thanks

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
