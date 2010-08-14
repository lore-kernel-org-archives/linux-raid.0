From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: md's fail to assemble correctly consistently at system startup -
 mdadm 3.1.2 and Ubuntu 10.04
Date: Sat, 14 Aug 2010 09:57:01 -0700
Message-ID: <AANLkTi=uckUyaKwQ6NhMApsgK2P_pDJkzLhV3Zerb68P@mail.gmail.com>
References: <AANLkTinQgx1t0eaXuFKLnf+5PBw1AqJpyYfxo-AvZXQf@mail.gmail.com>
	<20100808185806.69085415@notabene>
	<AANLkTi=j5WddChbtjBRCJFc=6XvOmEGL3bZdqJ3NfNeK@mail.gmail.com>
	<20100809210019.3cc064ab@notabene>
	<AANLkTi=_LKK7t1zPfcBwdTaSj6xDcBX9XAWbuN7mnPZD@mail.gmail.com>
	<AANLkTikiC+YF8ZtND2ub6mY_9o0zLQT+4jW1zzhA-98x@mail.gmail.com>
	<20100812114321.6d4462b5@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100812114321.6d4462b5@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil and Dan,

This patch does seem to have fixed the issue for me.

Thanks!
-Tommy

On Wed, Aug 11, 2010 at 6:43 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 10 Aug 2010 22:17:19 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Mon, Aug 9, 2010 at 4:58 AM, fibreraid@gmail.com <fibreraid@gmail=
=2Ecom> wrote:
>> > Hi Neil,
>> >
>> > I may have spoken a bit too soon. It seems that while the md's are
>> > coming up successfully, on occasion, hot-spares are not coming up
>> > associated with their proper md's. As a result, what was a RAID 5 =
md
>> > with one hot-spare will on occasion come up as a RAID 5 md with no
>> > hot-spare.
>> >
>> > Any ideas on this one?
>> >
>>
>> Is this new behavior only seen with 3.1.3, i.e when it worked with
>> 3.1.2 did the hot spares always arrive correctly? =A0I suspect this =
is a
>> result of the new behavior of -I to not add devices to a running arr=
ay
>> without the -R parameter, but you don't want to make this the defaul=
t
>> for udev otherwise your arrays will always come up degraded.
>>
>> We could allow disks to be added to active non-degraded arrays, but
>> that still has the possibility of letting a stale device take the
>> place of a fresh hot spare (the whole point of changing the behavior
>> in the first place). =A0So as far as I can see we need to query the
>> other disks in the active array and permit the disk to be re-added t=
o
>> an active array when it is demonstrably a hot spare (or -R is
>> specified).
>>
>> --
>> Dan
>
>
> Arg... another regression.
>
> Thanks for the report and the analysis.
>
> Here is the fix.
>
> NeilBrown
>
> From ef83fe7cba7355d3da330325e416747b0696baef Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 12 Aug 2010 11:41:41 +1000
> Subject: [PATCH] Allow --incremental to add spares to an array.
>
> Commit 3a6ec29ad56 stopped us from adding apparently-working devices
> to an active array with --incremental as there is a good chance that =
they
> are actually old/failed devices.
>
> Unfortunately it also stopped spares from being added to an active
> array, which is wrong. =A0This patch refines the test to be more
> careful.
>
> Reported-by: <fibreraid@gmail.com>
> Analysed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/Incremental.c b/Incremental.c
> index e4b6196..4d3d181 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -370,14 +370,15 @@ int Incremental(char *devname, int verbose, int=
 runstop,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strcpy(chosen_name, de=
vnum2devname(mp->devnum));
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It is generally not OK to add drives=
 to a running array
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* as they are probably missing becau=
se they failed.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* However if runstop is 1, then the =
array was possibly
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* started early and our best be is t=
o add this anyway.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* It would probably be good to allow=
 explicit policy
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* statement about this.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It is generally not OK to add non-sp=
are drives to a
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* running array as they are probably=
 missing because
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* they failed. =A0However if runstop=
 is 1, then the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* array was possibly started early a=
nd our best be is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to add this anyway. =A0It would pr=
obably be good to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allow explicit policy statement ab=
out this.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (runstop < 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((info.disk.state & (1<<MD_DISK_SYNC=
)) !=3D 0
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && runstop < 1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int active =3D 0;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (st->ss->external) =
{
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
