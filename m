From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 15:59:51 +0000
Message-ID: <5A4FA0F7.40007@youngman.org.uk>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
 <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
 <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
 <85891f3d-eaf6-9127-b55a-dea9d21d180b@fnarfbargle.com>
 <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
 <6b7ed6c2-497a-2b8d-4cd4-d7a8620bba75@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b7ed6c2-497a-2b8d-4cd4-d7a8620bba75@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Alexander Shenkin <al@shenkin.org>, Brad Campbell <brad@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/01/18 13:50, Phil Turmel wrote:
> The output of fdisk is invalid on your system, see the warning it
> printed.  Use gdisk or parted instead.  Don't use '*'.

It used to be so simple - fdisk for MBR disks, gdisk et al for GPT.

ashdown src # fdisk /dev/sda

Welcome to fdisk (util-linux 2.26.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 47915407-BA7E-4869-8D3E-3CB44F5FDA12

Device         Start        End    Sectors  Size Type
/dev/sda1       2048    1050623    1048576  512M BIOS boot
/dev/sda2    1312768   68421631   67108864   32G Linux swap
/dev/sda3   68683776  270010367  201326592   96G Linux filesystem
/dev/sda4  270272512  471599103  201326592   96G Linux filesystem
/dev/sda5  471861248 5860533134 5388671887  2.5T Linux filesystem

Command (m for help): q

ashdown src #

Modern fdisk now supports GPT. So yes, in this case the warning is
correct, but we need to watch out that people will be using fdisk, and
it's okay. Dunno when this happened, but I've only very recently noticed it.

Cheers,
Wol
