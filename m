From: Mark Keisler <grimm26@gmail.com>
Subject: Re: RAID10 failure(s)
Date: Tue, 15 Feb 2011 11:47:53 -0600
Message-ID: <AANLkTi=6GLBJSYrMXctLncEXC-HT66Jy++uxPq1yhGmQ@mail.gmail.com>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
	<AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
	<20110215094802.44d99c58@notabene.brown>
	<AANLkTimk-Z2EqaOFM87zgQEvBPE6H0wS9_acp83Gc4+5@mail.gmail.com>
	<20110215102007.0851f3b8@notabene.brown>
	<AANLkTi=5+2WJzg4=7cdWx-1+vUwyLcyHxKishCtX_nOH@mail.gmail.com>
	<20110215115744.3dd078b0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215115744.3dd078b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 14, 2011 at 6:57 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 14 Feb 2011 18:49:03 -0600 Mark Keisler <grimm26@gmail.com> w=
rote:
>
>> Oh, duh, was thinking in 0+1 instead of 10. =A0I'm still wondering w=
hy
>> you made mention of "but be really sure that the devices really are
>> working before you try this." =A0If trying to bring the RAID back fa=
ils,
>> I'm just back to not having access to the data which is where I am n=
ow
>> :).
>
> If you try reconstructing the array before you are sure you have reso=
lved the
> original problem (be it BIOS setting, bad cables, dodgey controller o=
r even a
> bad disk drive) then you risk compounding your problems and at least =
are
> likely to waste time.
> Sometimes people are in such a hurry to get access to their data that=
 they
> cut corners to their detriment. =A0I don't know if you are such a per=
son, but
> I mentioned it anyway just in case.
>
> NeilBrown
>
>
After checking things over, SMART tests were showing quite a few
Offline_Uncorrectable and  a high Current_Pending_Sector count on the
two drives that had failed out of the array.  So, based on that, I
figured I had nothing to lose in trying to create the array again.  I
just went with the array in a degraded state with 3 drives and was
able to activate the volumes on it and get the part of the data off
that wasn't backed up yet before it failed again.

Stan's dd zero idea also confirms with its output and logs:
 # dd if=3D/dev/zero of=3D/dev/sdb
dd: writing to `/dev/sdb': Input/output error
9368201+0 records in
9368200+0 records out
4796518400 bytes (4.8 GB) copied, 229.128 s, 20.9 MB/s


So, RMA of drives, keep smartd running, rebuild the array, load some
data and monitor :).  Thanks for the help guys.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
