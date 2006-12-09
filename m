From: Jiri Slaby <jirislaby@gmail.com>
Subject: oops on 2.6.19-rc6-mm2: deref of 0x28 at permission+0x7
Date: Sat, 09 Dec 2006 02:19:49 +0059
Message-ID: <457A0F4C.9060601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I got this oops on 2.6.19-rc6-mm2 when starting the system. It happened only
once -- when echo "raidautorun /dev/md0" | nash --quiet was executed. I don't
know why it happened, after reboot it started OK.

There is no md0, only md1, md2 and md3.

See camera-shots here:
http://www.fi.muni.cz/~xslaby/sklad/dm_oops1.png
http://www.fi.muni.cz/~xslaby/sklad/dm_oops2.png

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
