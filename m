From: Markus Irle <tha.bear@gmail.com>
Subject: Re: Wrong array size detected after reboot
Date: Sun, 16 Sep 2012 01:32:06 +0200
Message-ID: <CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120910091352.38dfdc20@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

Thanks for your help.

On Mon, Sep 10, 2012 at 1:13 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 08 Sep 2012 22:52:18 -0400 Phil Turmel <philip@turmel.org> wrote:

**snip**

>> Until recently, due to a long-standing bug, devices larger than 2T were
>> not usable with v0.90 meta-data.  I don't remember precisely when that
>> bug was fixed, but I believe it was in the past year.  There are also
>> potential identification problems with v0.90 when used on the last
>> partition of a device, but you have a misalignment warning that would
>> prevent that.
>
> The bug was fixed in 3.1-rc6, (commit 27a7b260f71439c40546)

I'm running 3.2 (3.2.0-31-generic, latest in current Ubuntu release 12.04) now.

>> You should see that the used dev size is very close to 2TiB less than
>> the actual size of your devices.
>>
>> First, try the latest stable mainline kernel that you can.  That should
>> let you back up your data.

Unfortunately nothing's changed.

The array still thinks it's small:
[    1.693557]  --- level:5 rd:3 wd:3
[    1.693559]  disk 0, o:1, dev:sdb1
[    1.693561]  disk 1, o:1, dev:sdd1
[    1.693562]  disk 2, o:1, dev:sde1
[    1.693593] md2: detected capacity change from 0 to 1603139141632

and the vg doesn't start:
[    1.778499] device-mapper: table: 252:0: md2 too small for target:
start=384, len=11721064448, dev_size=3131131136

Cheers,
Markus
