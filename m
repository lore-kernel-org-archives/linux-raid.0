From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: Sysfs update frequency
Date: Tue, 16 Mar 2010 15:25:06 -0700
Message-ID: <150c16851003161525g50e09917rfa9b53be3a500978@mail.gmail.com>
References: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com>
	 <20100317085256.6caee9bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317085256.6caee9bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 16, 2010 at 2:52 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 16 Mar 2010 14:32:55 -0700
> Justin Maggard <jmaggard10@gmail.com> wrote:
>
>> I've noticed on recent kernels that /sys/block/md?/md/sync_completed
>> seems to rarely get updated. =A0What is the expected update interval=
?
>> For me, it seems to only update about once every 6% or so during the
>> resync. =A0Of course, /proc/mdstat has the actual current progress.
>
> The expected update time is every 6% - actually 1/16 which is 6.25%.
>
> sync_completed includes a guarantee that all blocks before this point=
 really
> have been processed. =A0The number in /proc/mdstat is less precise. =A0=
The much
> of the array has been resynced, but due to the possibility of out-of-=
order
> completion of writes they may not be a contiguous series of blocks.
>
> Providing the guarantee (which is needed for externally-managed metad=
ata)
> requires briefly stalling the resync, so I didn't want to do it more =
often.
> I could possibly make it time-bases instead of size-based though.
>
> Is this a problem for you?
>

Thanks for the info.  No, it's not much of a problem, really.  Just
seemed strange that an array of 2TB disks could resync for an hour
with no update to sync_completed.  I thought I remembered older
kernels updating a lot more frequently, but I could be wrong about
that.  So I take it that point is where the resync would resume if the
system was rebooted?

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
