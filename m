From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Sysfs update frequency
Date: Tue, 16 Mar 2010 16:03:08 -0700
Message-ID: <4877c76c1003161603n26d29db5s2b3d271ca5698ee0@mail.gmail.com>
References: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com>
	 <20100317085256.6caee9bb@notabene.brown>
	 <150c16851003161525g50e09917rfa9b53be3a500978@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150c16851003161525g50e09917rfa9b53be3a500978@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 16, 2010 at 3:25 PM, Justin Maggard <jmaggard10@gmail.com> =
wrote:
> On Tue, Mar 16, 2010 at 2:52 PM, Neil Brown <neilb@suse.de> wrote:
>> On Tue, 16 Mar 2010 14:32:55 -0700
>> Justin Maggard <jmaggard10@gmail.com> wrote:
>>
>>> I've noticed on recent kernels that /sys/block/md?/md/sync_complete=
d
>>> seems to rarely get updated. =A0What is the expected update interva=
l?
>>> For me, it seems to only update about once every 6% or so during th=
e
>>> resync. =A0Of course, /proc/mdstat has the actual current progress.
>>
>> The expected update time is every 6% - actually 1/16 which is 6.25%.
>>
>> sync_completed includes a guarantee that all blocks before this poin=
t really
>> have been processed. =A0The number in /proc/mdstat is less precise. =
=A0The much
>> of the array has been resynced, but due to the possibility of out-of=
-order
>> completion of writes they may not be a contiguous series of blocks.
>>
>> Providing the guarantee (which is needed for externally-managed meta=
data)
>> requires briefly stalling the resync, so I didn't want to do it more=
 often.
>> I could possibly make it time-bases instead of size-based though.
>>
>> Is this a problem for you?
>>
>
> Thanks for the info. =A0No, it's not much of a problem, really. =A0Ju=
st
> seemed strange that an array of 2TB disks could resync for an hour
> with no update to sync_completed. =A0I thought I remembered older
> kernels updating a lot more frequently, but I could be wrong about
> that. =A0So I take it that point is where the resync would resume if =
the
> system was rebooted?
>
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Rather than a time basis would it be possible to have a sysfs
paramater which could be tuned via write?

Candidates for this would be something like:

sync_flushes_per_action (fractional unit, every 1/N of the device)

OR

sync_flush_stripes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
