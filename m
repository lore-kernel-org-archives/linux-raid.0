From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Sat, 24 Dec 2016 15:47:52 +0100
Message-ID: <CAOxFTcwiYC6VSHGnzKTUikiwLrue-SH-GrhweSCfM6CvmByvTQ@mail.gmail.com>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
 <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
 <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
 <87k2arpmvt.fsf@notabene.neil.brown.name> <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
 <CAOxFTcwaDfK+gKX2d4L4DuX=pf273M8qKGGOo8G+iAVSxurHhA@mail.gmail.com> <87a8bmp8el.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8bmp8el.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 11:50 PM, NeilBrown <neilb@suse.com> wrote:
> On Sat, Dec 24 2016, Giuseppe Bilotta wrote:
>>
>>
>> So the array assembles, and raid6check reports no error, but the data
>> is actually inaccessible .. am I missing other aspects of the metadata
>> that need to be restored?
>
> Presumably, yes.
>
> If you provide "mdadm --examine" from devices in both the "working" and
> the "not working" case, I might be able to point to the difference.

I found the culprit. All disks have bad block lists, and the bad block
lists include the initial data sectors (i.e. the sectors pointed at by
the data offset in the superblock). This is quite probably a side
effect of my stupid idea of trying a re-add of all disks after all of
them were kicked out during the JBOD disconnect. One more reason to
just stop the array when this situation arises.

-- 
Giuseppe "Oblomov" Bilotta
