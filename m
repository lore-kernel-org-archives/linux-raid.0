From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Thu, 25 Apr 2013 13:38:17 +0200
Message-ID: <15025553.voJ1cqAbWd@storm>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com> <51732422.1050109@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51732422.1050109@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday, 21. April 2013 02:26:26 Andrei Banu wrote:
> They are connected through SATA2 ports (this does explain the read speed
> but not the pitiful write one) in AHCI.

So the SATA controller is already in AHCI mode. Good.

You didn't say what kind of server hardware you are using or I missed it.
On the HP DL3xxx servers we usually use, we have to enable AHCI mode _and_ 
the write cache in the BIOS. Maybe your server needs something similar.

Some RAID controllers only allow you to enable the write cache
when a battery-backed write cache module is installed.

HTH,
Thomas

