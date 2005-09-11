From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Promise SATAII150 TX4 or raidreconf broken
Date: Mon, 12 Sep 2005 01:50:56 +1000
Message-ID: <43245260.6030907@eyal.emu.id.au>
References: <430E4AB0.2060600@eyal.emu.id.au> <4313E433.1080602@pobox.com>	<43223709.8090002@eyal.emu.id.au> <x3kfysdq846.fsf@Psilocybe.Update.UU.SE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <x3kfysdq846.fsf@Psilocybe.Update.UU.SE>
Sender: linux-raid-owner@vger.kernel.org
To: Thorild Selen <thorild@Update.UU.SE>
Cc: linux-ide@vger.kernel.org, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thorild Selen wrote:
> If you search a bit in the linux-ide and linux-kernel mailing list
> archives, you will find that several people before have had problems
> with SATA150-TX4 and SATAII150-TX4 (see for example posts by Jim
> Ramsay, Joerg Sommrey and me).

Following up on this information I did more testing.

I verified that creating a 2-disk raid-5 and extending it to 3 disks
always works. 3-disk to 4-disk end up corrupted.

BTW I had to change the check in raidreconf for a minimum of raid5
disks from 3 to 2. It worked just fine.

I then moved the first two disks to the motherboard (sd[cd] left on
the TX4). The situation remained the same (but I did get better
performance).

I am now less inclined to blame the TX4 and lean more towards
raidreconf.

I need to create a final test where I hit the disks concurrently
without raidreconf to see how they fair...

I did some tests and so far failed to provoke any i/o error.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
