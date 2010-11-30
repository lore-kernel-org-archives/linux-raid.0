From: hansbkk@gmail.com
Subject: Re: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Tue, 30 Nov 2010 12:35:56 +0700
Message-ID: <AANLkTimbFpDaUZ-VAHOpALDXyYzJJOV_szjr7EeB7Qxd@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com>
	<AANLkTinUmZoqSWNZ7NK+tg5DTpc5JFbbPPZV6YONq+ox@mail.gmail.com>
	<20101129152916.GB13310@www2.open-std.org>
	<AANLkTikPbbGbqRgF=ZR+nw-7Lf7_zcwcMtSsXzOowvFu@mail.gmail.com>
	<20101130114257.01134d62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101130114257.01134d62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 7:42 AM, Neil Brown <neilb@suse.de> wrote:
> If you are comparing recovering after some sort of problem with
> a RAID10 over 6 devices compared with  LVM over 2 2-device RAID1s, th=
en the
> former is certainly easier.  This is simply because there are less la=
yers of
> complexity where something could go wrong.
>
> In both cases, your data will be spread across multiple disks, and an=
y one
> disk or even any two disks would be of no use to you.


Thanks Neil.

Still true with LVM on top of the 6-drive set in either case?


Scenario being
 All the drives are together and OK (generic SATA2, cleanly
disconnected) - but everything else is gone
 Not practical to rebuild the whole set of hosts, just want to get at k=
ey data
 Mount the disks on a new machine, boot from SystemRescueCD or Knoppix
 and copy the key data off.


And between RAID6 and RAID10?


> On Mon, 29 Nov 2010 23:00:19 +0700 hansbkk@gmail.com wrote:
>
>> 2010/11/29 Keld J=F8rn Simonsen <keld@keldix.com>:
>> >> I can see how RAID6 is simpler than RAID10, but compared to RAID1=
?
>> >
>> > Hmm, does not compute by me. RAID1 and RAID10 are the same in comp=
lexity,
>> > RAID10 is just a modern RAID1, and should actually have been calle=
d
>> > RAID1.
>>
>> My understanding is that if I use RAID10 on a single pair of disks
>> then that is literally the same as RAID1. These to me are very simpl=
e
>> in that I can take either one of the pair and mount it on any normal
>> machine and get at the data without doing anything special.
>>
>> However, if I have my six disks configured as a single RAID10 array,=
 I
>> believe this is no longer true - the data from (at least the larger
>> of) the files has been distributed over all six disks, correct?
>>
>> Now compare putting LVM on top of this array, compared to three RAID=
1
>> pairs on the one hand and a RAID6 array on the other (third) hand :)
>>
>> If I were trying to recover the data using the latest version of a
>> LiveCD - say Fedora or Knoppix, which would be easier?
>>
>> I'm not trying to score any points, it's a genuine question.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
