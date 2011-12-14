From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Wed, 14 Dec 2011 12:27:43 +0200
Message-ID: <CAGRgLy7fs5AUGk1a+Cp36VgqRvP23fYWx_GM9yViJM6YmmMdSw@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
	<CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
	<CAGRgLy5huVzdA8q6V887Ay384kJ4ywgst6dEGgYuRg9+SxHB0A@mail.gmail.com>
	<20110831124646.21be9e25@notabene.brown>
	<CAGRgLy62uavK+9qosizaOey1Utz6STC+2fvOVqEbmi0HZbrQtw@mail.gmail.com>
	<20111206141608.0cca224a@notabene.brown>
	<CAGRgLy6++0C5xJAP4B6rY1Gs-Ht-EdcbS04VEdANfq83eXKGsg@mail.gmail.com>
	<20111207082103.0f86b3d6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207082103.0f86b3d6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, tim.gardner@canonical.com, gregkh@suse.de
List-Id: linux-raid.ids

Hello Neil,
we are looking at Ubuntu-oneiric kernel 3.0.0-14.23.
We see that this fix was delivered to it by the following commit:
---------------------------------
commit 5669de653e363cfaf2a2c7c48ea224a730f5a7a9
Author: NeilBrown <neilb@suse.de>
Date:   Wed Oct 26 10:31:04 2011 +1100

    md/raid5: fix bug that could result in reads from a failed device.

    BugLink: http://bugs.launchpad.net/bugs/890952

    commit 355840e7a7e56bb2834fd3b0da64da5465f8aeaa upstream.
------------------------------------
However, when looking at the diff, we see that only handle_stripe6()
function was fixed and not handle_stripe5(). That also explains why we
saw this issue on oneiric with raid5. Here is the diff:
----------------------------------------------------------
alex@ubuntu-alyakas-srv:/mnt/share/src/ubuntu-oneiric$ git diff
ccfe5df60a583cbad36969344679903585e2eac7
5669de653e363cfaf2a2c7c48ea224a730f5a7a9
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2581ba1..e509147 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3369,7 +3369,7 @@ static void handle_stripe6(struct stripe_head *sh=
)
                        /* Not in-sync */;
                else if (test_bit(In_sync, &rdev->flags))
                        set_bit(R5_Insync, &dev->flags);
-               else {
+               else if (!test_bit(Faulty, &rdev->flags)) {
                        /* in sync if before recovery_offset */
                        if (sh->sector + STRIPE_SECTORS <=3D
rdev->recovery_offset)
                                set_bit(R5_Insync, &dev->flags);
-----------------------------------------------

What is the reason the fix for raid5 was not applied there? Should we
apply the same fix for raid5 as well manually?
Copying also other two persons signed on the commit.

Thanks,
  Alex.


On Tue, Dec 6, 2011 at 11:21 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 6 Dec 2011 23:07:53 +0200 Alexander Lyakas <alex.bolshoy@gmai=
l.com>
> wrote:
>
>> Thanks, Neil!!!
>> Looks like this patch solves the issue. I applied it manually though=
,
>> for some reason git refused to apply it.
>>
>> Thanks again for great help,
>> =A0 Alex.
>
> Great. =A0Thanks for the confirmation.
>
> NeilBrown
>
>
>>
>>
>> On Tue, Dec 6, 2011 at 5:16 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 27 Nov 2011 11:56:17 +0200 Alexander Lyakas <alex.bolshoy@=
gmail.com>
>> > wrote:
>> >
>> >> Hello Neil,
>> >> we have compiled the natty kernel with dynamic debugging enabled =
for
>> >> raid456, and reproduced the problem.
>> >> The kernel log is available at
>> >> https://docs.google.com/open?id=3D0B9rmyUifdvMLMzk1YjYwZDUtYzhhYi=
00MDRlLTkzYjItMDM0Y2ZhZmU3ZDRk
>> >>
>> >> Some more information:
>> >> - array was created at Nov 27 11:28:03
>> >> - manual drive failure was issued at 11:28:09
>> >>
>> >> Please let me know if you need any additional information.
>> >>
>> >
>> > Hi,
>> > =A0sorry for the long delay, I've had a lot of distractions this p=
ast week.
>> >
>> > I looks like you are hitting the bug fixed by upstream commit
>> > =A0 =A0355840e7a7e56bb2834fd3b0da64da5465f8aeaa
>> >
>> > The symptoms are slightly different to those described in that com=
mit but I'm
>> > sure the root problem is the same.
>> >
>> > That patch doesn't apply to 2.6.38 though.
>> > Use this one.
>> >
>> > NeilBrown
>> >
>> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> > index 78536fd..8144126 100644
>> > --- a/drivers/md/raid5.c
>> > +++ b/drivers/md/raid5.c
>> > @@ -3086,7 +3086,7 @@ static void handle_stripe5(struct stripe_hea=
d *sh)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Not in-sync */;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (test_bit(In_sync, &rdev->f=
lags))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(R5_Insync, =
&dev->flags);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!test_bit(Faulty, &rdev->fl=
ags)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* could be in-sync=
 depending on recovery/reshape status */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sh->sector + ST=
RIPE_SECTORS <=3D rdev->recovery_offset)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set=
_bit(R5_Insync, &dev->flags);
>> > @@ -3377,7 +3377,7 @@ static void handle_stripe6(struct stripe_hea=
d *sh)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Not in-sync */;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (test_bit(In_sync, &rdev->f=
lags))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(R5_Insync, =
&dev->flags);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!test_bit(Faulty, &rdev->fl=
ags)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* in sync if befor=
e recovery_offset */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sh->sector + ST=
RIPE_SECTORS <=3D rdev->recovery_offset)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set=
_bit(R5_Insync, &dev->flags);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
