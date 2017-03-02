From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Thu, 2 Mar 2017 13:17:52 +0000
Message-ID: <58B81B80.6020708@youngman.org.uk>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
 <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Peter Sangas <pete@wnsdev.com>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/17 18:29, Phil Turmel wrote:
> Since this worked before, I would guess your grub was updated and its md
> support was left out.  Hopefully someone with more grub experience can
> chip in here -- I don't use any bootloader on my servers any more.

Look at the raid wiki

https://raid.wiki.kernel.org/index.php/Converting_an_existing_system

it mentions grub.

Also, look up grub2 and raid on the gentoo wiki - I wrote a lot of that,
and arch also apparently has very good documentation.

Cheers,
Wol
