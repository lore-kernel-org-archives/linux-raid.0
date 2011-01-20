From: Roberto Spadim <roberto@spadim.com.br>
Subject: cpu/memory use
Date: Wed, 19 Jan 2011 22:14:45 -0200
Message-ID: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, i wass thinking about cpu/memory use
i have a dual (three four) cpu
could i make linux to only use cpu1 for raid? and others to anythink
else, don=B4t migrate raid between cpus... and don=B4t allow others
programs to use raid cpu...
is it possible?
is it dificult?
it=B4s more linux related feature, not raid related, but could we imple=
ment it?
what about memory usage? how many memory software raid use? is it per
device, per raid, does it have a hard limit (offcourse)? could we
calculate it? for example i want raid1 with two disks of 1tb, how many
memory should i buy?

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
