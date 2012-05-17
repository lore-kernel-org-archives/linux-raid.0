From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 14:02:25 -0700
Message-ID: <CAA9_cmd=tXvfWkgm1efsZmaWMgXQeuOdX0pAHrLC_-KejyseKw@mail.gmail.com>
References: <4FB4534A.5070608@volatilevoid.net>
	<20120517113817.7faf9c1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120517113817.7faf9c1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 16, 2012 at 6:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 17 May 2012 03:24:26 +0200 Oliver Martin <oliver@volatilevoid=
=2Enet>
> wrote:
>
>> Hi,
>>
>> is there any specific reason why md refuses to create a RAID6 array =
with
>> 3 disks? My (probably naive) understanding suggests it should be the
>> same as a 3-disk RAID1, similar to a 2-disk RAID5.
>
> I'll have to leave for for hpa to answer. =A0I've occasionally though=
t that
> maybe it should be fixed, but it never seemed worth the effort.

The math assumes 2 data disks.

>> The reason I'm asking is that I currently have space on three disks =
for
>> a new array, and would like to expand it when I add a fourth. I trie=
d
>> this scenario with a few loopback devices, but the only way to go fr=
om a
>> 3-disk RAID1 to a 4-disk RAID6 seems to be via an intermediate 3-dis=
k
>> RAID5, requiring two reshapes. I'd like to avoid one of them, if at =
all
>> possible.
>
> Yes, not possible at present.
> It might be as simple and finding the places that impose the limit an=
d delete
> them...

You'd certainly need to route around the acceleration code, because
that increased the dependency on the assumption that there is always
two data disk slots.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
