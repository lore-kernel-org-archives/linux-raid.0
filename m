From: Rory Jaffe <rsjaffe@gmail.com>
Subject: Re: Doing 'echo repair > /sys/devices/virtual/block/md?/md/sync_action'
 does not result in mismatch_cnt of 0 on RAID-6?
Date: Fri, 1 Apr 2011 16:48:07 -0700
Message-ID: <AANLkTimk7hezjWxp+pYAkd98LNb2eu2atHaYq4VfnGQg@mail.gmail.com>
References: <4D7F4DF3.7010804@tuxes.nl>
	<20110315121351.GA7190@cthulhu.home.robinhill.me.uk>
	<4D7F6CE5.4010303@tuxes.nl>
	<20110315141342.GB7190@cthulhu.home.robinhill.me.uk>
	<4D965555.10504@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D965555.10504@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had the same question and ended up looking at the source. The kernel
documentation was maddeningly vague about this.

/drivers/md/raid5.c (which handles both 5 and 6), has, in procedure
handle_parity_checks5 and handle_parity_checks6 similar comments:

/* handle a successful check operation, if parity is correct
		 * we are done.  Otherwise update the mismatch count and repair
		 * parity if !MD_RECOVERY_CHECK
		 */
and the program logic does just that--update the count, then check for
the flag, and repair if the flag isn't set.

And in /drivers/md/md.c the section that parses the command has the fol=
lowing:

if (cmd_match(page, "check"))
			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
		else if (!cmd_match(page, "repair"))
			return -EINVAL;
		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
So it looks like the only difference between check and repair is the
MD_RECOVERY_CHECK flag, which is set for check only.


On Fri, Apr 1, 2011 at 3:44 PM, Bas van Schaik <bas@tuxes.nl> wrote:
> On 03/15/2011 02:13 PM, Robin Hill wrote:
>> On Tue Mar 15, 2011 at 01:43:01PM +0000, Bas van Schaik wrote
>>> My other question is still standing:
>>>> Furthermore, theoretically it should be possible to indicate which
>>>> device in the RAID-6 array contains the inconsistent data, or am I
>>>> mistaking? If so, that would certainly be a nice feature to see
>>>> implemented, as it would help diagnosing problems.
>>> Am I indeed correct in thinking this?
>> I'm not sure. If it's a single data block that's failed then you sho=
uld
>> be able to, for each disk, re-generate the data using the other disk=
s
>> and the P parity, then validate against the Q parity (if it matches =
then
>> that disk is the incorrect one). You should also be able to detect
>> errors in either the P or Q parity (if one is valid for the data and=
 the
>> other isn't). =C2=A0If there's multiple disks which are incorrect th=
en I
>> don't think there's any way you can tell which (or even avoid having=
 one
>> of the correct disks flagged as incorrect).
> Indeed, that is what I was thinking. As I've just discovered some new
> block mismatches (that's 2 weeks after the last repair!) on my 8x2TB
> RAID6 array, it would be really nice to see this feature implemented.=
=2E.
> I would be happy to contribute, but I am not very experienced in hack=
ing
> kernel C.
>
> Any tips, tricks and/or suggestions anyone?
>
> Cheers,
>
> =C2=A0Bas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
