From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Why does md3 persist after deleting and recreating the partitions?
Date: Thu, 30 Dec 2010 17:33:50 -0800
Message-ID: <AANLkTimBPdQjiayvZ1HN2y7DgvtEjUsG0KpRNEA1jgO_@mail.gmail.com>
References: <AANLkTik9quhP_h-vWji8nex8QT6X+_Ss2_KQiVSr5AK6@mail.gmail.com>
	<AANLkTikrCJMpvkzNQE-PC_r-Fk=zD+OSG=rnLAvqnR+O@mail.gmail.com>
	<AANLkTimWL8boLkV-byGk1am52HbDPvn0weyP1+0+0-9q@mail.gmail.com>
	<AANLkTikv4WgxTmBO496Hx7k-YEpsF-iCVzmMFydw_S=Y@mail.gmail.com>
	<AANLkTinJwh8mcPS79pgKARP_jJaYLKyVp2gv3x=T3fmw@mail.gmail.com>
	<20101231120733.5439205c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101231120733.5439205c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 30, 2010 at 5:07 PM, Neil Brown <neilb@suse.de> wrote:
> On Thu, 30 Dec 2010 16:17:51 -0800 Mark Knecht <markknecht@gmail.com>=
 wrote:
>
>> On Thu, Dec 30, 2010 at 4:16 PM, Mathias Bur=C3=A9n <mathias.buren@g=
mail.com> wrote:
>> > On 31 December 2010 00:14, Mark Knecht <markknecht@gmail.com> wrot=
e:
>> >> On Thu, Dec 30, 2010 at 4:12 PM, Mathias Bur=C3=A9n <mathias.bure=
n@gmail.com> wrote:
>> >>> On 31 December 2010 00:10, Mark Knecht <markknecht@gmail.com> wr=
ote:
>> >>>> Hi,
>> >>>> =C2=A0 What am I forgetting to do? I had a RAID1 using sd{a,b,c=
}3. I
>> >>>> stopped md3, removed the md3 line in /etc/mdadm.conf, deleted t=
he
>> >>>> partitions using fdisk, and then created 5 new partitions using
>> >>>> sd{a,b,c,d,e}3 to get ready to do a 5 disk RAID6. The new parti=
tions
>> >>>> are the same size as the old ones and located at the same secto=
r
>> >>>> addresses.
>> >>>>
>> >>>> =C2=A0 After rebooting, but before creating the new RAID6, I st=
ill see md3:
>> >>>>
>> >>>> mark@c2stable ~ $ cat /proc/mdstat
>> >>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid=
5] [raid4]
>> >>>> md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
>> >>>> =C2=A0 =C2=A0 =C2=A0247416933 blocks super 1.1 [3/3] [UUU]
>> >>>>
>> >>>> md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
>> >>>> =C2=A0 =C2=A0 =C2=A052436096 blocks [3/3] [UUU]
>> >>>>
>> >>>> md5 : active raid1 sdc5[2] sdb5[1] sda5[0]
>> >>>> =C2=A0 =C2=A0 =C2=A052436032 blocks [3/3] [UUU]
>> >>>>
>> >>>> unused devices: <none>
>> >>>> mark@c2stable ~ $
>> >>>>
>> >>>>
>> >>>> =C2=A0 What am I doing wrong or forgetting? I would like md3 to=
 be totally
>> >>>> gone before I create a new md3 in it's place.
>> >>>>
>> >>>> Thanks,
>> >>>> Mark
>> >>>> --
>> >>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>> >>>> the body of a message to majordomo@vger.kernel.org
>> >>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>> >>>>
>> >>>
>> >>> Erase the superblocks? Recreating partitions doesn't (usually) a=
ffect
>> >>> the data on the HDDs.
>> >>>
>> >>> // M
>> >>>
>> >>
>> >> Is erasing the superblocks a mdadm operation? I've not heard of t=
hat one before.
>> >>
>> >> Thanks,
>> >> Mark
>> >>
>> >
>> > Yes, see mdadm --misc. Like:
>> >
>> > mdadm --zero-superblock <device>
>> >
>> > // M
>> >
>>
>> Yes, just found that.
>>
>> Can I still use /dev/md3 safely even though it's no longer in
>> mdadm.conf? I suspect I can?
>
> That sentence doesn't make much sense to me, so I suspect some misund=
erstand
> is going on. =C2=A0So to be explicit:
>
> =C2=A0Use
> =C2=A0 =C2=A0mdadm --zero-superblock /dev/sdc3 /dev/sdb3 /dev/sda3
>
> =C2=A0to remove =C2=A0from those devices any record that they are par=
t of any md array.
>
> Does that clarify thing sufficienty?
>
> NeilBrown

Yes, making sure to do

mdadm -S /dev/md3

first.

/dev/md3 seems to be gone at this point. On to doing the new RAID6.
(See other thread - no one has responded to that one yet.)

Thanks again,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
