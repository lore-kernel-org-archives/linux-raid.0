From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Growing an Array?
Date: 11 Nov 2002 10:33:03 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <aqot4v$os5$1@cesium.transmeta.com>
References: <A506359028CAD21191C10008C75D895C040B8850@NPRI54EXC14.NPT.NUWC.NAVY.MIL> <20021106173553.163A03B807@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20021106173553.163A03B807@jaded.cynicism.com>
By author:    Derek Vadala <derek@cynicism.com>
In newsgroup: linux.dev.raid
>
> On Wed, 6 Nov 2002, Huntress Gary B NPRI wrote:
> 
> > Actually I meant an array of six 73GB drives switching to six 180GB
> > drives, but thats conceptually the same.
> 
> I think that your best bet is to bring the new array online and copy the
> data over using traditional methods. That's going to be the fastest way to
> get the new array online. The other methods (backup and restore,
> raidreconf) are either slower or don't apply specifically to this case.
> 

Note that in large-scale data moves, like this, where you're reluctant
to take the system offline: if you can put the new storage online
(connected either to the same or a different server) you run the copy
process while the data is still online, then when you close for the
migration you can do an incremental update (rsync -aHS --delete is
good for this; if you want to be extra paranoid at the expense of
significantly slower execution rsync -acHS --delete.)  This is
typically a lot quicker than copying all the data once offline.

	-hpa

-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
"Unix gives you enough rope to shoot yourself in the foot."
http://www.zytor.com/~hpa/puzzle.txt	<amsp@zytor.com>
