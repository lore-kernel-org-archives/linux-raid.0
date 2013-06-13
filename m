From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: Help with failed RAID-5 -> 6 migration
Date: Thu, 13 Jun 2013 10:09:17 -0400
Message-ID: <51B9D28D.8040702@turmel.org>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com> <51B3B7FF.9080800@turmel.org> <CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com> <CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com> <51B62A8A.9070108@turmel.org> <CAASLJ=52pzLpk179U=SY+5aGmEe+XcSfrEuBLC_o1ThPvAXfew@mail.gmail.com> <51B6FF7E.1000707@turmel.org> <CAASLJ=6eEVY6DeZ=+9Aw6yXmqNSc5mygqtD_8y+MaUid6B_TcQ@mail.gmail.com> <51B88AB2.5060303@turmel.org> <CAASLJ=7=hnez3udgc4Voa_i7drZq_Y-8FkOgxt02_ROL5eD3qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=7=hnez3udgc4Voa_i7drZq_Y-8FkOgxt02_ROL5eD3qg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Phillips <spootsy.ootsy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/13/2013 09:58 AM, Keith Phillips wrote:
>> You won't be able to assemble and run your array without a backup file.
>>  You said you lost your original, so you will have to use a blank one
>> and tell mdadm to ignore the invalid file.
> 
> Ah, didn't realise this was an option. After a brief googling it seems
> my version of mdadm pre-dated the "--invalid-backup" option.
> 
> Cloned the git repo and built a newer version, and re-assembled with
> an empty "--backup-file" and the "--invalid-backup" option. Now it's
> chugging along happily again - at %20 and counting now, no errors in
> sight!

Good to hear. :-)

> Will do an ext4 fsck once it's finished the grow. Are there any tips
> for determining what data I trashed by losing the backup-file? Or is
> it just a case of trying to access stuff and seeing what's broken?

You have the reshape position where the process stopped in the original
mdadm -E reports.  Use that to query for inodes that contain those
sectors, then look up those inodes.

A quick google came up with:
http://smartmontools.sourceforge.net/badblockhowto.html

You'll have to reinterpret that to use the sector offsets in your array
rather than sector offset from smartctl.

> Thanks so much for the help, Phil :)

You're welcome.

Phil

