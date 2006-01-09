From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: [linux-lvm] Re: more info on the hang with 2.6.15-rc5
Date: Mon, 9 Jan 2006 18:46:13 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0601091842140.14030@shaka.acc.umu.se>
References: <E1EpIfb-0001e2-GR@highlab.com> <43C1580B.9020609@tmr.com>
 <E1Evmqw-0001pO-Ng@highlab.com> <43C28E52.8080104@mattgillen.net>
 <E1Ew0a0-0002eu-Qt@highlab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1Ew0a0-0002eu-Qt@highlab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Jan 2006, Sebastian Kuzminsky wrote:

> Matthew Gillen <me@mattgillen.net> wrote:
>> Sebastian Kuzminsky wrote:
>>> Still broken in 2.6.15.  With all the debugging options OFF in the config,
>>> the system stayed up < 24 hours under load, then a hard lockup like
>>> before: nothing on the console, magic sysrq doesnt work, no caps-lock,
>>> no ping.  Note that this is different from before: it actually ran a
>>> little bit before locking up, rather than locking up within seconds like
>>> it did with 2.6.15-rc5.
>>
>> I couldn't quite tell from your description: are you getting the lockup
>> when you try to mount a filesystem that uses the RAID+LVM as a device?
>> Or do you get errors when doing LVM-level stuff (ie no filesystem can
>> even be put on the device)?
>> In the case of the former, what filesystem are you using?
>
> No errors ever, just hard lockups.

Just wanted to add that I recently starting to see similar behaviour (hard 
lockups with no errors during heavy writing to the filesystem) on 
raid5+lvm+reiserfs after adding 6 sata_sil-connected disks in raid5 to an 
already existing vg of a couple of pata raid5s. This is 2.6.14 though, and 
I haven't ruled out hw issues yet (going to put a beefier PSU in it 
first), but it might be related.

I'm going to try adding debugging symbols to make it stable after the PSU 
upgrade, if that doesn't fix it. :)

/Mattias Wadenstein
